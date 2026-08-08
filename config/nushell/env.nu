# Load the system PATH from the login shell / path_helper.
if (uname | get operating-system) == 'Darwin' {
    $env.PATH = (/usr/libexec/path_helper | parse 'PATH="{path}";{_}').path
    $env.ANDROID_NDK_HOME = '/opt/homebrew/share/android-ndk'
} else if (uname | get operating-system) == 'Linux' {
    $env.PATH = (^/bin/bash -l -c 'echo $PATH')
}

$env.PATH = ($env.PATH | split row (char esep) | where {|p| $p != ""})

def --env path_prepend [path: string] {
    $env.PATH = ($env.PATH | where {|p| $p != $path} | prepend $path)
}

def --env path_append [path: string] {
    $env.PATH = ($env.PATH | where {|p| $p != $path} | append $path)
}

def --env setup_wsl_env [] {
    let winpath = do {
        cd /mnt/c
        ((^/mnt/c/Windows/System32/cmd.exe /c 'echo %PATH:\\=/%') | split row ";")
    }
    for p in $winpath {
        path_append (/usr/bin/wslpath -u $"($p)")
    }
    $env.DISPLAY = ":0"
    $env.WAYLAND_DISPLAY = "wayland-0"
}

if (uname | get operating-system) == "Darwin" {
    path_prepend "/usr/local/bin"
    if (uname | get machine) =~ "^arm64" {
        path_prepend "/opt/homebrew/bin"
    }
    if (which brew | length) > 0 {
        $"eval (brew shellenv)\nenv | grep '^HOMEBREW\\|^MANPATH\\|^INFOPATH'" | sh | parse "{k}={v}" | transpose -r -d | load-env
    }
}

if (which "/mnt/c/Windows/System32/cmd.exe" | length) > 0 {
    setup_wsl_env
}

path_prepend ([$env.HOME, ".pixi", "bin"] | path join)
path_prepend ([$env.HOME, ".cargo", "bin"] | path join)
path_prepend ([$env.HOME, ".local", "bin" ] | path join)

mkdir ($nu.data-dir | path join "autoload")

starship init nu | save -f ($nu.data-dir | path join "autoload/starship.nu")
pixi completion --shell nushell | save -f $"($nu.data-dir)/autoload/pixi-completions.nu"

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

if (uname | get operating-system) =~ 'MS/Windows' and (which scoop | length) > 0 {
    luajit ([(scoop prefix z.lua), 'z.lua'] | path join) --init nushell | save -f "~/.cache/zlua.nu"
} else if (which brew | length) > 0 {
    luajit ([(brew --prefix), 'share/z.lua/z.lua'] | path join) --init nushell | save -f "~/.cache/zlua.nu"
}
