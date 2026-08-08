if (uname).operating-system =~ 'MS/Windows' {
    $env.TERM = 'xterm-256color'
} else if (^infocmp $env.TERM | complete).exit_code != 0 {
    $env.TERM = 'xterm-256color'
}

$env.config.show_banner = false
$env.config.use_ansi_coloring = true
$env.config.use_kitty_protocol = true # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.

# osc2 abbreviates the path if in the home_dir which we do not want here.
$env.config.shell_integration.osc2 = false

# The default is now `inherit`; we want an explicit line cursor in emacs mode.
$env.config.cursor_shape.emacs = "line"

$env.config.hooks.pre_prompt = [{
    print -n $"(ansi title)(pwd | str replace $nu.home-dir "~" | path basename)(ansi st)"

    # Search for pixi.toml in the current directory and all parent directories
    mut project_root = $env.PWD
    while not ([$project_root, "pixi.toml"] | path join | path exists) {
        let new_project_root = [$project_root, ".."] | path join | path expand -n
        if $new_project_root == $project_root {
            break
        }
        $project_root = $new_project_root
    }
    let found_project = [$project_root, "pixi.toml"] | path join | path exists

    export-env {
        if ("PIXI_IN_SHELL" in $env) and $env.PIXI_IN_SHELL == "1" { # and (not $found_project or $env.PIXI_PROJECT_ROOT != $project_root) {
            # Deactivate for every prompt for now, in case any files have changed
            # Try to find a better solution in the future
            # print $"(ansi blue)Deactivating (ansi attr_bold)($env.PIXI_PROJECT_NAME)(ansi reset)"
            if "PIXI_OLD_PROMPT" in $env {
                $env.PROMPT_COMMAND = $env.PIXI_OLD_PROMPT
                hide-env PIXI_OLD_PROMPT
            }
            if "PIXI_SAVE_ENV" in $env {
                $env.PIXI_SAVE_ENV | where {|e| $e.v != null } | transpose -ird | load-env
                $env.PIXI_SAVE_ENV | where {|e| $e.v == null } | each {|e| $e.k } | hide-env ...$in
                hide-env PIXI_SAVE_ENV
            }
        }

        if $found_project {
            # Get the pixi activation script for nushell
            let hook_script = (pixi shell-hook -s nushell --manifest-path ([$project_root, "pixi.toml"] | path join))
            # Extract only $env.X = ... lines, excluding PROMPT_COMMAND
            let env_lines = ($hook_script | lines | where {|l| ($l | str starts-with "$env.") and not ($l | str contains "PROMPT_COMMAND") })
            let env_keys = ($env_lines | each {|l| $l | parse "$env.{key} = {rest}" | get 0.key })
            # Run the activation in a subshell and capture the resulting env vars
            let new_env = (nu -c ($env_lines | append $"$env | select ...($env_keys) | to nuon" | str join "\n") | from nuon)

            # Save current values of those keys for later restoration
            let envs_to_save = $env_keys | each {|k|
                if $k in $env {
                    { k: $k, v: ($env | get $k) }
                } else {
                    { k: $k, v: null }
                }
            }
            $env.PIXI_SAVE_ENV = $envs_to_save
            $new_env | load-env
            $env.PIXI_OLD_PROMPT = $env.PROMPT_COMMAND
            $env.PROMPT_COMMAND = {||
                let old_prompt = (do $env.PIXI_OLD_PROMPT)
                if ($old_prompt | str starts-with "\n") {
                    # If the old prompt starts with a newline, we need to trim it
                    # This is the case when starship is used and add_newline is set to true in starship.toml
                    echo $"\n($env.PIXI_PROMPT)($old_prompt | str trim --left)"
                } else {
                    echo $"($env.PIXI_PROMPT)($old_prompt)"
                }
            }
        }
    }
}]

$env.config.hooks.pre_execution = [{
    let last_cmd = (commandline)
    if $last_cmd != "" {
        print -n $"(ansi title)(pwd | str replace $nu.home-dir "~" | path basename)·($last_cmd)(ansi st)"
    } else {
        print -n $"(ansi title)(pwd | str replace $nu.home-dir "~" | path basename)(ansi st)"
    }
}]

# Only the IDE completion menu is customized; the rest use Nushell defaults.
$env.config.menus = ($env.config.menus | append {
    name: ide_completion_menu
    only_buffer_difference: false
    marker: ""
    type: {
        layout: ide
        min_completion_width: 0,
        max_completion_width: 300,
        max_completion_height: 20, # will be limited by the available lines in the terminal
        padding: 0,
        border: true,
        cursor_offset: 0,
        description_mode: "prefer_right"
        min_description_width: 0
        max_description_width: 50
        max_description_height: 10
        description_offset: 0
        # If true, the cursor pos will be corrected, so the suggestions match up with the typed text
        #
        # C:\> str
        #      str join
        #      str trim
        #      str split
        correct_cursor_pos: true
    }
    # Use terminal default colors plus attributes so the menu keeps a
    # moderate, readable contrast on both light and dark backgrounds.
    style: {
        text: default
        selected_text: { attr: r }
        description_text: { fg: default attr: d }
        match_text: { fg: default attr: bu }
        selected_match_text: { attr: bur }
    }
})

$env.config.keybindings = ($env.config.keybindings | append [
    {
        name: ide_completion_menu
        modifier: none
        keycode: tab
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { send: menu name: ide_completion_menu }
                { send: menunext }
                { edit: complete }
            ]
        }
    }
    {
        name: move_up
        modifier: control
        keycode: char_p
        mode: [emacs, vi_normal, vi_insert]
        event: {
            until: [
                { send: menuup }
                { send: up }
            ]
        }
    }
    {
        name: move_down
        modifier: control
        keycode: char_n
        mode: [emacs, vi_normal, vi_insert]
        event: {
            until: [
                { send: menudown }
                { send: down }
            ]
        }
    }
])

source ~/.cache/carapace/init.nu
source ~/.cache/zlua.nu

alias zc = z -c
alias zi = z -i
alias zf = z -I
alias zb = z -b
alias zbi = z -b -i
alias zbf = z -b -I
alias zh = z -I -t .

alias la = ls -al
alias ll = ls -l
alias wsl = wsl.exe
alias winget = winget.exe

def --wrapped ssh [ ...args ] {
    with-env { TERM: xterm-256color } { ^ssh ...$args }
}

def px [] {}
def --wrapped 'px add'      [ ...args ] { ^pixi global add --environment default ...$args }
def --wrapped 'px install'  [ ...args ] { ^pixi global install --environment default ...$args }
def --wrapped 'px expose'   [ ...args ] { ^pixi global expose add --environment default ...$args }
def --wrapped 'px link'     [ ...args ] { ^pixi global expose add --environment default ...$args }
def --wrapped 'px list'     [ ...args ] { ^pixi global list ...$args }
def --wrapped 'px remove'   [ ...args ] { ^pixi global remove --environment default ...$args }
def --wrapped 'px search'   [ ...args ] { ^pixi search ...$args }
def --wrapped 'px unexpose' [ ...args ] { ^pixi global expose remove ...$args }
def --wrapped 'px unlink'   [ ...args ] { ^pixi global expose remove ...$args }
def --wrapped 'px update'   [ ...args ] { ^pixi global update ...$args; ^pixi self-update }

def 'vpn on' [] {
    sudo systemctl start openconnect.service
}

def 'vpn off' [] {
    sudo systemctl stop openconnect.service
}

alias t = /bin/sh -c 'tmux attach || tmux new'
