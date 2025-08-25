local wezterm = require('wezterm')
local brglng = require("brglng")
local WINDOWS = wezterm.target_triple == "x86_64-pc-windows-msvc"
local MAC = wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin"

local config = wezterm.config_builder()

config.front_end = "OpenGL"

if WINDOWS then
    config.set_environment_variables = {
        TERMINFO_DIRS = wezterm.home_dir .. '/.terminfo',
        WSLENV = 'TERMINFO_DIRS',
    }
end

config.term = "wezterm"

if wezterm.hostname():find('^APSH-') then
    config.hyperlink_rules = {}
end

-- Colors

config.colors = {
    selection_fg = "none"
}

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

local function scheme_for_appearance(appearance)
    if appearance:find('Dark') then
        return 'melange_dark'
    else
        return 'melange_light'
    end
end

config.colors = wezterm.color.load_scheme(wezterm.config_dir .. "/colors/" .. scheme_for_appearance(get_appearance()) .. ".toml")
local function set_tabline_colors(config)
    local tabline_fg = config.colors.foreground
    local tabline_bg = brglng.color.darken(config.colors.background, 0.15)
    local tab_active_fg = config.colors.foreground
    local tab_active_bg = config.colors.background
    local tab_inactive_bg = brglng.color.darken(config.colors.background, 0.07)
    local tab_inactive_fg = brglng.color.blend(tab_active_fg, tab_inactive_bg, 0.5)
    local tab_inactive_hover_bg = brglng.color.darken(config.colors.background, 0.03)
    config.colors.tab_bar = {
        background = tabline_bg,
        active_tab = {
            fg_color = tab_active_fg,
            bg_color = tab_active_bg,
            intensity = 'Bold',
        },
        inactive_tab = {
            fg_color = tab_inactive_fg,
            bg_color = tab_inactive_bg,
        },
        inactive_tab_hover = {
            fg_color = tab_inactive_fg,
            bg_color = tab_inactive_hover_bg,
            italic = false,
        },
        new_tab = {
            fg_color = tabline_fg,
            bg_color = tabline_bg,
        },
        new_tab_hover = {
            fg_color = tab_inactive_fg,
            bg_color = tab_inactive_hover_bg,
            italic = false,
        }
    }
end
set_tabline_colors(config)

-- GUI Appearance

config.scrollback_lines = 100000
config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.tab_max_width = 100
config.window_decorations = "RESIZE"
local window_min = ' 󰖰 '
local window_max = ' 󰖯 '
local window_close = ' 󰅖 '
config.tab_bar_style = {
    window_hide = window_min,
    window_hide_hover = window_min,
    window_maximize = window_max,
    window_maximize_hover = window_max,
    window_close = window_close,
    window_close_hover = window_close,
}
config.window_padding = {
    left = 0,
    right = '1cell',
    top = 0,
    bottom = 0
}

local function tab_title(tab_info, max_width)
    local pane = tab_info.active_pane
    local title = tostring(tab_info.tab_index + 1) .. ' '
    if pane.domain_name ~= config.default_domain then
        title = title .. pane.domain_name .. ":"
    end
    -- if the tab title is explicitly set, take that
    if tab_info.tab_title and #tab_info.tab_title > 0 then
        title = title .. tab_info.tab_title
    else
        -- Otherwise, use the title from the active pane
        -- in that tab
        title = title .. tab_info.active_pane.title
    end
    title = title:gsub(":", " > ")
    return title:sub(1, math.max(max_width - 4, 0))
end

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local title = tab_title(tab, max_width)
        if tab.is_active then
            return {
                { Foreground = { Color = config.colors.tab_bar.active_tab.bg_color } },
                { Background = { Color = config.colors.tab_bar.background } },
                { Text = '' },
                { Foreground = { Color = config.colors.tab_bar.active_tab.fg_color } },
                { Background = { Color = config.colors.tab_bar.active_tab.bg_color } },
                { Attribute = { Intensity = 'Bold' } },
                { Text = " " .. title .. " " },
                "ResetAttributes",
                { Foreground = { Color = config.colors.tab_bar.active_tab.bg_color } },
                { Background = { Color = config.colors.tab_bar.background } },
                { Text = '' },
            }
        else
            if hover then
                return {
                    { Foreground = { Color = config.colors.tab_bar.inactive_tab_hover.bg_color } },
                    { Background = { Color = config.colors.tab_bar.background } },
                    { Text = '' },
                    { Foreground = { Color = config.colors.tab_bar.inactive_tab_hover.fg_color } },
                    { Background = { Color = config.colors.tab_bar.inactive_tab_hover.bg_color } },
                    { Text = " " .. title .. " " },
                    { Foreground = { Color = config.colors.tab_bar.inactive_tab_hover.bg_color } },
                    { Background = { Color = config.colors.tab_bar.background } },
                    { Text = '' },
                }
            else
                return {
                    { Foreground = { Color = config.colors.tab_bar.inactive_tab.bg_color } },
                    { Background = { Color = config.colors.tab_bar.background } },
                    { Text = '' },
                    { Foreground = { Color = config.colors.tab_bar.inactive_tab.fg_color } },
                    { Background = { Color = config.colors.tab_bar.inactive_tab.bg_color } },
                    { Text = " " .. title .. " " },
                    { Foreground = { Color = config.colors.tab_bar.inactive_tab.bg_color } },
                    { Background = { Color = config.colors.tab_bar.background } },
                    { Text = '' },
                }
            end
        end
    end
)

config.status_update_interval = 300
wezterm.on("update-status", function(window, pane)
    local colors = window:effective_config().colors
    local tabbar_bg = colors.tab_bar.background
    local tab_active_bg = colors.tab_bar.active_tab.bg_color
    local tab_inactive_fg = colors.tab_bar.inactive_tab.fg_color
    local leader, modes
    if get_appearance():find('Dark') then
        leader = { text = ' 󱐋 ', fg = '#34302c', bg = '#d47766' }
        modes = {
            copy_mode = { text = " 󰆏 ", fg = '#34302c', bg = '#ebc06d' },
            search_mode = { text = " 󰍉 ", fg = '#34302c', bg = '#cf9bc2' },
            window_mode = { text = " 󱂬 ", fg = '#34302c', bg = '#c1a78e' },
            font_mode = { text = " 󰛖 ", fg = '#34302c', bg = '#c1a78e' },
            lock_mode = { text = "  ", fg = '#34302c', bg = '#c1a78e' },
        }
    else
        leader = { text = ' 󱐋 ', fg = '#e9e1db', bg = '#bf0021' }
        modes = {
            copy_mode = { text = " 󰆏 ", fg = '#e9e1db', bg = '#a06d00' },
            search_mode = { text = " 󰍉 ", fg = '#e9e1db', bg = '#904180' },
            window_mode = { text = " 󱂬 ", fg = '#e9e1db', bg = '#7d6658' },
            font_mode = { text = " 󰛖 ", fg = '#e9e1db', bg = '#7d6658' },
            lock_mode = { text = "  ", fg = '#e9e1db', bg = '#7d6658' },
        }
    end

    if window:leader_is_active() then
        window:set_left_status(wezterm.format {
            { Foreground = { Color = leader.bg } },
            { Background = { Color = tabbar_bg } },
            { Text = "" },
            { Foreground = { Color = tab_active_bg } },
            { Background = { Color = leader.bg } },
            { Attribute = { Intensity = 'Bold' } },
            { Text = '󱐋' },
            { Foreground = { Color = leader.bg } },
            { Background = { Color = tabbar_bg } },
            { Text = " " }
        })
    else
        local name = window:active_key_table()
        if name and modes[name] then
            window:set_left_status(wezterm.format {
                { Foreground = { Color = modes[name].bg.bg } },
                { Background = { Color = tabbar_bg } },
                { Text = "" },
                { Foreground = { Color = modes[name].fg } },
                { Background = { Color = modes[name].bg } },
                { Attribute = { Intensity = 'Bold' } },
                { Text = modes[name].text },
                { Foreground = { Color = modes[name].bg.bg } },
                { Background = { Color = tabbar_bg } },
                { Text = " " }
            })
        else
            window:set_left_status(wezterm.format {
                { Foreground = { Color = tabbar_bg } },
                { Background = { Color = tabbar_bg } },
                { Text = "" },
                { Foreground = { Color = tabbar_bg } },
                { Background = { Color = tabbar_bg } },
                { Attribute = { Intensity = 'Bold' } },
                { Text = ' ' },
                { Foreground = { Color = tabbar_bg } },
                { Background = { Color = tabbar_bg } },
                { Text = " " }
            })
        end
    end
end)

-- Fonts

config.allow_square_glyphs_to_overflow_width = "Always"
-- config.freetype_interpreter_version = 40
config.freetype_load_flags = "NO_HINTING|NO_AUTOHINT"
config.freetype_load_target = "Light"
config.freetype_render_target = "Light"
config.font = wezterm.font_with_fallback {
    "Maple Mono NF CN",
    "Flog Symbols",
}

if WINDOWS then
    config.font_size = 10.0
else
    config.font_size = 14.0
end

config.enable_kitty_graphics = true

-- Keys

-- config.enable_kitty_keyboard = true
config.allow_win32_input_mode = true
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 5000 }

config.keys = {
    { mods = 'CTRL | SHIFT', key = ':', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY | COMMANDS' } },
    { mods = 'LEADER | CTRL', key = 'a', action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } },
    { mods = 'LEADER', key = 'b', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY | TABS' } },
    { mods = 'LEADER', key = 'c', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY | LAUNCH_MENU_ITEMS' } },
    { mods = 'LEADER', key = 'd', action = wezterm.action.DetachDomain('CurrentPaneDomain') },
    { mods = 'LEADER', key = 'h', action = wezterm.action.ActivatePaneDirection('Left') },
    { mods = 'LEADER', key = 'j', action = wezterm.action.ActivatePaneDirection('Down') },
    { mods = 'LEADER', key = 'k', action = wezterm.action.ActivatePaneDirection('Up') },
    { mods = 'LEADER', key = 'l', action = wezterm.action.ActivatePaneDirection('Right') },
    { mods = 'LEADER', key = 'n', action = wezterm.action.ActivateTabRelative(1) },
    { mods = 'LEADER', key = 'o', action = wezterm.action.TogglePaneZoomState },
    { mods = 'LEADER', key = 'p', action = wezterm.action.ActivateTabRelative(-1) },
    { mods = 'LEADER', key = 'q', action = wezterm.action.CloseCurrentPane { confirm = true } },
    { mods = 'LEADER', key = 's', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { mods = 'LEADER', key = 'v', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { mods = 'LEADER', key = '[', action = wezterm.action.ActivateCopyMode },
    { mods = 'LEADER | CTRL', key = '[', action = wezterm.action.ActivateCopyMode },
    { mods = 'LEADER', key = ']', action = wezterm.action.PasteFrom('PrimarySelection') },
    { mods = 'LEADER | CTRL', key = ']', action = wezterm.action.PasteFrom('PrimarySelection') },
    { mods = 'LEADER', key = '1', action = wezterm.action.ActivateTab(0), },
    { mods = 'LEADER', key = '2', action = wezterm.action.ActivateTab(1), },
    { mods = 'LEADER', key = '3', action = wezterm.action.ActivateTab(2), },
    { mods = 'LEADER', key = '4', action = wezterm.action.ActivateTab(3), },
    { mods = 'LEADER', key = '5', action = wezterm.action.ActivateTab(4), },
    { mods = 'LEADER', key = '6', action = wezterm.action.ActivateTab(5), },
    { mods = 'LEADER', key = '7', action = wezterm.action.ActivateTab(6), },
    { mods = 'LEADER', key = '8', action = wezterm.action.ActivateTab(7), },
    { mods = 'LEADER', key = '9', action = wezterm.action.ActivateTab(8), },
    { mods = 'LEADER', key = '0', action = wezterm.action.ActivateTab(9), },
    { mods = 'LEADER', key = '-', action = wezterm.action.ActivateTab(10), },
    { mods = 'LEADER', key = '=', action = wezterm.action.ActivateTab(11), },
    { mods = 'ALT', key = '`', action = wezterm.action.SendKey { key = '`', mods = 'ALT' } },
    { mods = 'ALT', key = '1', action = wezterm.action.SendKey { key = '1', mods = 'ALT' } },
    { mods = 'ALT', key = '2', action = wezterm.action.SendKey { key = '2', mods = 'ALT' } },
    { mods = 'ALT', key = '3', action = wezterm.action.SendKey { key = '3', mods = 'ALT' } },
    { mods = 'ALT', key = '4', action = wezterm.action.SendKey { key = '4', mods = 'ALT' } },
    { mods = 'ALT', key = '5', action = wezterm.action.SendKey { key = '5', mods = 'ALT' } },
    { mods = 'ALT', key = '6', action = wezterm.action.SendKey { key = '6', mods = 'ALT' } },
    { mods = 'ALT', key = '7', action = wezterm.action.SendKey { key = '7', mods = 'ALT' } },
    { mods = 'ALT', key = '8', action = wezterm.action.SendKey { key = '8', mods = 'ALT' } },
    { mods = 'ALT', key = '9', action = wezterm.action.SendKey { key = '9', mods = 'ALT' } },
    { mods = 'ALT', key = '0', action = wezterm.action.SendKey { key = '0', mods = 'ALT' } },
    { mods = 'ALT', key = 'b', action = wezterm.action.SendKey { key = 'b', mods = 'ALT' } },
    { mods = 'ALT', key = 'f', action = wezterm.action.SendKey { key = 'f', mods = 'ALT' } },
    { mods = 'ALT', key = 'q', action = wezterm.action.SendKey { key = 'q', mods = 'ALT' } },
    { mods = 'ALT', key = '-', action = wezterm.action.SendKey { key = '-', mods = 'ALT' } },
    { mods = 'ALT', key = '=', action = wezterm.action.SendKey { key = '=', mods = 'ALT' } },
    { mods = 'ALT', key = ']', action = wezterm.action.SendKey { key = ']', mods = 'ALT' } },
    { mods = 'ALT', key = '\\', action = wezterm.action.SendKey { key = '\\', mods = 'ALT' } },

    { mods = 'ALT|SHIFT', key = '{', action = wezterm.action.ActivateTabRelative(-1) },
    { mods = 'ALT|SHIFT', key = '}', action = wezterm.action.ActivateTabRelative(1) },
    { mods = 'ALT|SHIFT', key = 'H', action = wezterm.action.MoveTabRelative(-1) },
    { mods = 'ALT|SHIFT', key = 'L', action = wezterm.action.MoveTabRelative(1) },
    { mods = 'ALT|SHIFT', key = 'P', action = wezterm.action.SendKey { key = 'P', mods = 'ALT|SHIFT' } },
}

-- Launcher

config.unix_domains = {
    {
        name = 'Mux',
        -- local_echo_threshold_ms = 300
    }
}

config.ssh_domains = {
    {
        name = 'SSH:VPS:Mux',
        remote_address = '3.112.158.72',
        username = 'ubuntu',
    },
    {
        name = 'SSH:VPS',
        remote_address = '3.112.158.72',
        username = 'ubuntu',
        multiplexing = 'None'
    }
}

config.launch_menu = {}

if WINDOWS then
    table.insert(config.ssh_domains, {
        name = 'SSH:WSL:Ubuntu:Mux',
        remote_address = 'localhost',
        username = 'brglng',
    })
    table.insert(config.ssh_domains, {
        name = 'SSH:WSL:Ubuntu',
        remote_address = 'localhost',
        username = 'brglng',
        multiplexing = 'None',
        default_prog = { '/bin/sh', '-c', 'if [ -x ~/.pixi/bin/nu ]; then exec ~/.pixi/bin/nu -l -i; elif [ -x ~/.pixi/bin/zsh ]; then exec ~/.pixi/bin/zsh -l -i; else exec bash -l -i; fi' }
    })

    config.default_domain = 'Mux'

    table.insert(config.launch_menu, {
        label = 'Mux ❯ Nushell',
        domain = { DomainName = "Mux" },
        args = { 'nu', '-i', '-l' },
    })
    table.insert(config.launch_menu, {
        label = 'SSH ❯ WSL ❯ Ubuntu ❯ Mux',
        domain = { DomainName = 'SSH:WSL:Ubuntu:Mux' }
    })
    table.insert(config.launch_menu, {
        label = 'Mux ❯ PowerShell',
        domain = { DomainName = "Mux" },
        args = { 'powershell.exe', '-NoLogo' },
    })
    table.insert(config.launch_menu, {
        label = "Mux ❯ Command Prompt",
        domain = { DomainName = "Mux", },
        args = { 'cmd.exe' }
    })
    table.insert(config.launch_menu, {
        label = "Mux ❯ Bose Cygwin 6.0",
        domain = { DomainName = "Mux" },
        args = {
            "cmd.exe", "/c",
            "C:\\cygwin64\\Cygwin.bat"
        }
    })
    table.insert(config.launch_menu, {
        label = 'Mux ❯ Developer Command Prompt for VS 2022 Community',
        domain = { DomainName = "Mux" },
        args = {
            'cmd.exe', '/k',
            "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\VsDevCmd.bat",
            '-startdir=none',
            '-arch=x64',
            '-host_arch=x64',
        },
    })
    table.insert(config.launch_menu, {
        label = 'Mux ❯ Developer Powershell for VS 2022 Community',
        domain = { DomainName = "Mux" },
        args = {
            'powershell.exe',
            '-NoExit',
            '-Command',
            '&{Import-Module "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell 3c97223e -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',
        },
    })
    -- table.insert(config.launch_menu, {
    --     label = 'Mux ❯ Developer Command Prompt for VS 2022 Professional',
    --     domain = { DomainName = "Mux" },
    --     args = {
    --         'cmd.exe', '/k',
    --         "C:\\Program Files\\Microsoft Visual Studio\\2022\\Professional\\Common7\\Tools\\VsDevCmd.bat",
    --         '-startdir=none',
    --         '-arch=x64',
    --         '-host_arch=x64',
    --     },
    -- })
    -- table.insert(config.launch_menu, {
    --     label = 'Mux ❯ Developer Powershell for VS 2022 Professional',
    --     domain = { DomainName = "Mux" },
    --     args = {
    --         'powershell.exe',
    --         '-NoExit',
    --         '-Command',
    --         '&{Import-Module "C:\\Program Files\\Microsoft Visual Studio\\2022\\Professional\\Common7\\Tools\\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell bf82c5b9 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',
    --     },
    -- })

    table.insert(config.launch_menu, {
        label = 'Nushell',
        domain = { DomainName = "local" },
        args = { 'nu', '-i', '-l' },
    })
    table.insert(config.launch_menu, {
        label = 'SSH ❯ WSL ❯ Ubuntu',
        domain = { DomainName = 'SSH:WSL:Ubuntu' }
    })
    table.insert(config.launch_menu, {
        label = 'PowerShell',
        domain = { DomainName = "local" },
        args = { 'powershell.exe', '-NoLogo' },
    })
    table.insert(config.launch_menu, {
        label = "Command Prompt",
        domain = { DomainName = "local", },
        args = { 'cmd.exe' }
    })
    table.insert(config.launch_menu, {
        label = "Bose Cygwin 6.0",
        domain = { DomainName = "local" },
        args = { "cmd.exe", "/c", "C:\\cygwin64\\Cygwin.bat" }
    })
    table.insert(config.launch_menu, {
        label = 'Developer Command Prompt for VS 2022 Community',
        domain = { DomainName = "local" },
        args = {
            'cmd.exe', '/k',
            'C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\VsDevCmd.bat',
            '-startdir=none',
            '-arch=x64',
            '-host_arch=x64',
        },
    })
    table.insert(config.launch_menu, {
        label = 'Developer Powershell for VS 2022 Community',
        domain = { DomainName = "local" },
        args = {
            'powershell.exe',
            '-NoExit',
            '-Command',
            '&{Import-Module "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell 3c97223e -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',
        },
    })
    -- table.insert(config.launch_menu, {
    --     label = 'Developer Command Prompt for VS 2022 Professional',
    --     domain = { DomainName = "local" },
    --     args = {
    --         'cmd.exe', '/k',
    --         'C:\\Program Files\\Microsoft Visual Studio\\2022\\Professional\\Common7\\Tools\\VsDevCmd.bat',
    --         '-startdir=none',
    --         '-arch=x64',
    --         '-host_arch=x64',
    --     },
    -- })
    -- table.insert(config.launch_menu, {
    --     label = 'Developer Powershell for VS 2022 Professional',
    --     domain = { DomainName = "local" },
    --     args = {
    --         'powershell.exe',
    --         '-NoExit',
    --         '-Command',
    --         '&{Import-Module "C:\\Program Files\\Microsoft Visual Studio\\2022\\Professional\\Common7\\Tools\\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell bf82c5b9 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',
    --     },
    -- })

    table.insert(config.launch_menu, {
        label = 'WSL ❯ Ubuntu',
        domain = { DomainName = 'WSL:Ubuntu' }
    })

    config.default_prog = { "nu.exe", "-i", "-l" }
else
    config.default_domain = 'Mux'
    if #wezterm.glob(wezterm.home_dir .. '/.pixi/bin/nu') ~= 0 then
        config.default_prog = { wezterm.home_dir .. '/.pixi/bin/nu', '-l', '-i'  }
    elseif #wezterm.glob(wezterm.home_dir .. '/.pixi/bin/zsh') ~= 0 then
        config.default_prog = { wezterm.home_dir .. '/.pixi/bin/zsh', '-l', '-i'  }
    elseif MAC then
        config.default_prog = { '/bin/zsh', '-l', '-i' }
    else
        config.default_prog = { '/usr/bin/bash', '-l', '-i' }
    end
    table.insert(config.launch_menu, {
        label = 'Mux',
        domain = { DomainName = 'Mux' }
    })
    table.insert(config.launch_menu, {
        label = 'local',
        domain = { DomainName = 'local' }
    })
end

table.insert(config.launch_menu, {
    label = 'SSH ❯ VPS ❯ Mux',
    domain = { DomainName = 'SSH:VPS:Mux' }
})
table.insert(config.launch_menu, {
    label = 'SSH ❯ VPS',
    domain = { DomainName = 'SSH:VPS' }
})

-- config.initial_rows = 40
-- config.initial_cols = 160

-- wezterm.on("gui-attached", function()
--     -- maximize all displayed windows on startup
--     local workspace = wezterm.mux.get_active_workspace()
--     for _, window in ipairs(wezterm.mux.all_windows()) do
--         if window:get_workspace() == workspace then
--             window:gui_window():maximize()
--         end
--     end
-- end)

-- config.exit_behavior = 'CloseOnCleanExit'

return config
-- vim: ts=4 sts=4 sw=4 et
