#!/bin/bash
# POSIX-compliant theme detector for macOS, Linux, and Windows (WSL)
# Returns: "dark" or "light"

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            if grep -qi microsoft /proc/version 2>/dev/null || \
               grep -qi wsl /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# macOS theme detection
detect_macos_theme() {
    if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
        echo "dark"
    else
        echo "light"
    fi
}

# Linux theme detection
detect_linux_theme() {
    # Try GNOME/GTK first (most common)
    if command -v gsettings >/dev/null 2>&1; then
        # GNOME 42+ with color-scheme setting
        color_scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
        case "$color_scheme" in
            *dark*|*Dark*)
                echo "dark"
                return
                ;;
            *light*|*Light*)
                echo "light"
                return
                ;;
        esac

        # Fallback to gtk-theme
        gtk_theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null)
        case "$gtk_theme" in
            *dark*|*Dark*)
                echo "dark"
                return
                ;;
        esac
    fi

    # Try KDE Plasma
    if command -v kreadconfig5 >/dev/null 2>&1; then
        kde_scheme=$(kreadconfig5 --group "General" --key "ColorScheme" 2>/dev/null)
        case "$kde_scheme" in
            *Dark*|*dark*)
                echo "dark"
                return
                ;;
        esac
    fi

    # Try reading GTK settings file directly
    if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
        gtk_theme=$(grep "^gtk-theme-name" "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null | cut -d= -f2 | tr -d ' ')
        case "$gtk_theme" in
            *dark*|*Dark*)
                echo "dark"
                return
                ;;
        esac
    fi

    # Try XDG desktop portal
    if command -v dbus-send >/dev/null 2>&1; then
        color_scheme=$(dbus-send --session --print-reply=literal --reply-timeout=100 \
            --dest=org.freedesktop.portal.Desktop \
            /org/freedesktop/portal/desktop \
            org.freedesktop.portal.Settings.Read \
            string:'org.freedesktop.appearance' \
            string:'color-scheme' 2>/dev/null | awk '{print $NF}')

        # 1 = dark, 2 = light in XDG portal spec
        case "$color_scheme" in
            1|*1*)
                echo "dark"
                return
                ;;
            2|*2*)
                echo "light"
                return
                ;;
        esac
    fi

    # Default to light if detection fails
    echo "light"
}

# WSL theme detection
detect_wsl_theme() {
    # Method 1: Try reading Windows registry via powershell.exe
    if command -v powershell.exe >/dev/null 2>&1; then
        # Get AppsUseLightTheme value (0 = dark, 1 = light)
        reg_value=$(powershell.exe -NoProfile -NonInteractive -Command \
            "try { (Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -ErrorAction Stop).AppsUseLightTheme } catch { 1 }" 2>/dev/null | \
            tr -d '\r\n ')

        case "$reg_value" in
            0)
                echo "dark"
                return
                ;;
            1)
                echo "light"
                return
                ;;
        esac
    fi

    # Method 2: Try reading Windows registry via reg.exe
    if command -v reg.exe >/dev/null 2>&1; then
        reg_output=$(reg.exe query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme 2>/dev/null | tr -d '\r')
        reg_value=$(echo "$reg_output" | grep "AppsUseLightTheme" | awk '{print $NF}')

        case "$reg_value" in
            0x0)
                echo "dark"
                return
                ;;
            0x1)
                echo "light"
                return
                ;;
        esac
    fi

    # Method 3: Try reading Windows Terminal settings
    # Convert potential Windows paths to WSL paths
    if [ -n "$LOCALAPPDATA" ]; then
        wt_settings_win="$LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    else
        wt_settings_win="/mnt/c/Users/$USER/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    fi

    if [ -f "$wt_settings_win" ]; then
        # Simple grep-based parsing (no jq dependency)
        theme=$(grep -o '"theme"[[:space:]]*:[[:space:]]*"[^"]*"' "$wt_settings_win" 2>/dev/null | \
                cut -d'"' -f4)

        case "$theme" in
            *dark*|*Dark*)
                echo "dark"
                return
                ;;
            *light*|*Light*)
                echo "light"
                return
                ;;
        esac
    fi

    # Fallback: Try Linux detection (some WSL distros expose GNOME settings)
    detect_linux_theme
}

# Main detection logic
main() {
    os=$(detect_os)

    case "$os" in
        macos)
            detect_macos_theme
            ;;
        linux)
            detect_linux_theme
            ;;
        wsl)
            detect_wsl_theme
            ;;
        *)
            echo "light"
            ;;
    esac
}

main
