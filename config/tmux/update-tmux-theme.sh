#!/bin/bash

get_script_dir() {
    script="$0"
    while [ -L "$script" ]; do
        script=$(readlink "$script")
    done
    dirname "$script"
}

mkdir -p "$HOME/.local/share/tmux"
THEME_FILE="$HOME/.local/share/tmux/theme.conf"
LOCK_DIR="/tmp/tmux-theme-watcher-$(id -u).lock"
PID_FILE="$LOCK_DIR/pid"

generate_theme() {
    local theme
    theme=$(bash "$(get_script_dir)/detect-theme.sh")

    if [ "$theme" = "dark" ]; then
        cat > "$THEME_FILE" << EOF
# Rose Pine (Dark)
set -g @status_bg '#0d0c13'
set -g @status_current_fg '#e0def4'
set -g @status_current_bg '#191724'
set -g @status_inactive_fg '#908caa'
set -g @status_inactive_bg '#171521'
set -g @status_a_bg '#ebbcba'
set -g @status_prefix_fg '#191724'
set -g @status_prefix_bg '#9ccfd8'
set -g @status_x_fg '#e0def4'
set -g @status_x_bg '#1f1d2e'
set -g @status_y_fg '#ebbcba'
set -g @status_y_bg '#26233a'
set -g @status_z_fg '#191724'
set -g @status_z_bg '#ebbcba'
EOF
    else
        cat > "$THEME_FILE" << EOF
# Rose Pine Dawn (Light)
set -g @status_bg '#c8c3bd'
set -g @status_current_fg '#575279'
set -g @status_current_bg '#faf4ed'
set -g @status_inactive_fg '#797593'
set -g @status_inactive_bg '#dcd6d0'
set -g @status_a_bg '#dcd6d0'
set -g @status_prefix_fg '#faf4ed'
set -g @status_prefix_bg '#56949f'
set -g @status_x_fg '#464261'
set -g @status_x_bg '#fffaf3'
set -g @status_y_fg '#d7827e'
set -g @status_y_bg '#f2e9e1'
set -g @status_z_fg '#faf4ed'
set -g @status_z_bg '#d7827e'
EOF
    fi
}

acquire_lock() {
    # mkdir is atomic
    if mkdir "$LOCK_DIR" 2>/dev/null; then
        echo $$ > "$PID_FILE"
        return 0
    else
        # directory exists, check if the process is still running
        if [ -f "$PID_FILE" ]; then
            old_pid=$(cat "$PID_FILE")
            if [ -n "$old_pid" ] && ! kill -0 "$old_pid" 2>/dev/null; then
                # old process is not running, clean up the lock
                echo "Cleaning up stale lock from PID $old_pid"
                rm -rf "$LOCK_DIR"
                mkdir "$LOCK_DIR" 2>/dev/null && echo $$ > "$PID_FILE" && return 0
            fi
        fi
        return 1
    fi
}

force_takeover() {
    if [ -f "$PID_FILE" ]; then
        old_pid=$(cat "$PID_FILE")
        if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
            echo "Force killing old process: $old_pid"
            kill -TERM "$old_pid" 2>/dev/null
            sleep 2
            kill -KILL "$old_pid" 2>/dev/null
        fi
    fi
    
    rm -rf "$LOCK_DIR"
    mkdir "$LOCK_DIR" 2>/dev/null && echo $$ > "$PID_FILE"
}


release_lock() {
    rm -rf "$LOCK_DIR"
}

check_lock() {
    [ -d "$LOCK_DIR" ] && [ -f "$PID_FILE" ] && [ "$(cat "$PID_FILE")" = "$$" ]
}

main() {
    if ! acquire_lock; then
        echo "Lock held by another process, forcing takeover..."
        force_takeover
        
        if ! check_lock; then
            echo "Failed to acquire lock" >&2
            exit 1
        fi
    fi

    trap release_lock EXIT INT TERM

    echo "Theme watcher started (PID: $$)"

    generate_theme
    if [ -f "$THEME_FILE" ]; then
        tmux source-file "$THEME_FILE" 2>/dev/null
    fi

    while true; do
        sleep 2

        if ! check_lock; then
            echo "Lock was taken over by another process, exiting..." >&2
            exit 0
        fi

        generate_theme
        if [ -f "$THEME_FILE" ]; then
            tmux source-file "$THEME_FILE" 2>/dev/null
        fi
    done
}

main
