local wezterm = require('wezterm')

local WINDOWS = wezterm.target_triple == "x86_64-pc-windows-msvc"
local MAC = wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin"

local config = wezterm.config_builder()

config.front_end = "WebGpu"

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
    if appearance:find 'Dark' then
        return 'melange_dark'
    else
        return 'melange_light'
    end
end

config.color_scheme = scheme_for_appearance(get_appearance())

-- GUI Appearance

config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
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

local function tab_title(tab_info)
    local pane = tab_info.active_pane
    local title = ""
    if pane.domain_name == 'local' then
    elseif pane.domain_name == 'Mux' then
    elseif pane.domain_name ~= nil then
        title = title .. pane.domain_name .. " "
    end
    if pane.current_working_dir.file_path ~= nil then
        local cwd, home_dir
        if WINDOWS then
            cwd = string.gsub(pane.current_working_dir.file_path, '^/(%u:)/', '%1/')
            home_dir = string.gsub(wezterm.home_dir, '\\', '/')
        else
            cwd = pane.current_working_dir.file_path
            home_dir = wezterm.home_dir
        end
        cwd = string.gsub(cwd, '^' .. home_dir, '~')
        title = title .. string.gsub(cwd, '(.*[/\\])([^/\\]*)', '%2')
    end
    if title ~= '' then
        title = title .. ' '
    end
    if pane.foreground_process_name ~= '' then
        title = title .. string.gsub(pane.foreground_process_name, '(.*[/\\])([^/\\]*)', '%2')
    else
        local process_name = string.gsub(pane.title, '^[^>]+> (.*)$', '%1')
        if process_name ~= pane.title then
            title = title .. process_name
        end
    end

    title = string.gsub(title, '(.*)%.exe', '%1')

    if #title == 0 then
        title = tab_info.title
        if #tab_info.title == 0 then
            title = tab_info.active_pane.title
        end
    end

    return title
    -- local title = tab_info.tab_title
    -- -- if the tab title is explicitly set, take that
    -- if title and #title > 0 then
    --     return title
    -- end
    -- -- Otherwise, use the title from the active pane
    -- -- in that tab
    -- return tab_info.active_pane.title
end

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local title = tostring(tab.tab_index + 1) .. '  ' .. tab_title(tab)

        local fg_separator_active, fg_separator_inactive, fg_active, fg_inactive
        if get_appearance():find('Dark') then
            fg_active = '#ece1d7'
            fg_inactive = '#c1a78e'
            fg_separator_active = '#34302c'
            fg_separator_inactive = '#161412'
            bg_active = '#292522'
        else
            fg_active = '#54433a'
            fg_inactive = '#7d6658'
            fg_separator_active = '#e9e1db'
            fg_separator_inactive = '#c0c0c0'
            bg_active = '#f1f1f1'
        end

        -- ensure that the titles fit in the available space,
        -- and that we have room for the edges.
        title = ' ' .. wezterm.truncate_right(title, max_width)

        if tab.is_active then
            return {
                { Foreground = { Color = fg_separator_active } },
                { Text = '▎' },
                { Foreground = { Color = fg_active } },
                { Text = title .. '  ' },
            }
        else
            return {
                { Foreground = { Color = fg_separator_inactive } },
                { Text = '▎' },
                { Foreground = { Color = fg_inactive } },
                { Text = title .. '  ' },
            }
        end
    end
)

config.status_update_interval = 100
wezterm.on("update-status", function(window, pane)
    local fg, bg, leader, modes
    if get_appearance():find('Dark') then
        fg = '#34302c'
        bg = '#161412'
        leader = { text = ' 󱐋 ', fg = '#34302c', bg = '#d47766' }
        modes = {
            copy_mode = { text = " 󰆏 ", fg = '#34302c', bg = '#ebc06d' },
            search_mode = { text = " 󰍉 ", fg = '#34302c', bg = '#cf9bc2' },
            window_mode = { text = " 󱂬 ", fg = '#34302c', bg = '#c1a78e' },
            font_mode = { text = " 󰛖 ", fg = '#34302c', bg = '#c1a78e' },
            lock_mode = { text = "  ", fg = '#34302c', bg = '#c1a78e' },
        }
    else
        fg = '#e9e1db'
        bg = '#c0c0c0'
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
            { Foreground = { Color = leader.fg } },
            { Background = { Color = leader.bg  } },
            { Attribute = { Intensity = 'Bold' } },
            { Text = ' 󱐋 ' },
        })
    else
        local name = window:active_key_table()
        if name and modes[name] then
            window:set_left_status(wezterm.format {
                { Foreground = { Color = modes[name].fg } },
                { Background = { Color = modes[name].bg } },
                { Attribute = { Intensity = 'Bold' } },
                { Text = modes[name].text },
            })
        else
            window:set_left_status(wezterm.format {
                { Foreground = { Color = fg } },
                { Background = { Color = bg } },
                { Attribute = { Intensity = 'Bold' } },
                { Text = '   ' },
            })
        end
    end
end)

if get_appearance():find 'Dark' then
    config.colors.tab_bar = {
        background = '#161412',
        active_tab = {
            fg_color = '#ece1d7',
            bg_color = '#292522',
            intensity = 'Bold',
        },
        inactive_tab = {
            fg_color = '#c1a78e',
            bg_color = '#1e1b19',
        },
        inactive_tab_hover = {
            fg_color = '#c1a78e',
            bg_color = '#25221f',
            italic = false,
        },
        new_tab = {
            fg_color = '#c1a78e',
            bg_color = '#161412',
        },
        new_tab_hover = {
            fg_color = '#c1a78e',
            bg_color = '#25221f',
            italic = false,
        }
    }
else
    config.colors.tab_bar = {
        background = '#c0c0c0',
        active_tab = {
            fg_color = '#54433a',
            bg_color = '#f1f1f1',
            intensity = 'Bold'
        },
        inactive_tab = {
            fg_color = '#7d6658',
            bg_color = '#d4d4d4',
            italic = false,
        },
        inactive_tab_hover = {
            fg_color = '#7d6658',
            bg_color = '#dddddd',
            italic = false,
        },
        new_tab = {
            fg_color = '#54433a',
            bg_color = '#c0c0c0',
        },
        new_tab_hover = {
            fg_color = '#54433a',
            bg_color = '#dddddd',
        },
    }
end

-- Fonts

config.allow_square_glyphs_to_overflow_width = "Always"
config.freetype_load_flags = "NO_HINTING|NO_AUTOHINT"
config.freetype_load_target = "Normal"
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
    { name = 'Mux' }
}

config.ssh_domains = {
    {
        name = 'SSH Mux VPS',
        remote_address = '3.112.158.72',
        username = 'ubuntu',
    },
    {
        name = 'SSH VPS',
        remote_address = '3.112.158.72',
        username = 'ubuntu',
        multiplexing = 'None'
    }
}

config.default_domain = 'local'

config.launch_menu = {}

if WINDOWS then
    table.insert(config.ssh_domains, {
        name = 'SSH WSL Ubuntu',
        remote_address = 'localhost',
        username = 'brglng',
        multiplexing = 'None',
        default_prog = { '/bin/bash', '-i', '-c', 'if type nu &> /dev/null; then nu -l -i; elif type zsh &> /dev/null; then zsh -l -i; else bash -i; fi' }
    })
    table.insert(config.ssh_domains, {
        name = 'SSH WSL Mux Ubuntu',
        remote_address = 'localhost',
        username = 'brglng',
    })

    table.insert(config.launch_menu, {
        label = 'Windows Nushell',
        domain = { DomainName = "local" },
        args = { 'nu', '-i', '-l' },
    })
    table.insert(config.launch_menu, {
        label = 'Windows PowerShell',
        domain = { DomainName = "local" },
        args = { 'powershell.exe', '-NoLogo' },
    })
    table.insert(config.launch_menu, {
        label = "Windows Command Prompt",
        domain = { DomainName = "local", },
        args = { 'cmd.exe' }
    })
    table.insert(config.launch_menu, {
        label = "Bose Cygwin 6.0",
        domain = { DomainName = "local" },
        args = {
            "cmd.exe",
            "/c",
            "C:/cygwin64/Cygwin.bat"
        }
    })
    table.insert(config.launch_menu, {
        label = 'SSH WSL Ubuntu',
        domain = { DomainName = 'SSH WSL Ubuntu' }
    })
    table.insert(config.launch_menu, {
        label = 'Developer Command Prompt for VS 2022 Community',
        domain = { DomainName = "local" },
        args = {
            'cmd.exe',
            '/k',
            'C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools/VsDevCmd.bat',
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
            '&{Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell 3c97223e -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',
        },
    })
    table.insert(config.launch_menu, {
        label = 'Developer Command Prompt for VS 2022 Professional',
        domain = { DomainName = "local" },
        args = {
            'cmd.exe',
            '/k',
            'C:/Program Files/Microsoft Visual Studio/2022/Professional/Common7/Tools/VsDevCmd.bat',
            '-startdir=none',
            '-arch=x64',
            '-host_arch=x64',
        },
    })
    table.insert(config.launch_menu, {
        label = 'Developer Powershell for VS 2022 Professional',
        domain = { DomainName = "local" },
        args = {
            'powershell.exe',
            '-NoExit',
            '-Command',
            '&{Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Professional/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell bf82c5b9 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',
        },
    })

    table.insert(config.launch_menu, {
        label = 'Mux Windows Nushell',
        domain = { DomainName = "Mux" },
        args = { 'nu', '-i', '-l' },
    })
    table.insert(config.launch_menu, {
        label = 'Mux Windows PowerShell',
        domain = { DomainName = "Mux" },
        args = { 'powershell.exe', '-NoLogo' },
    })
    table.insert(config.launch_menu, {
        label = "Mux Windows Command Prompt",
        domain = { DomainName = "Mux", },
        args = { 'cmd.exe' }
    })
    table.insert(config.launch_menu, {
        label = "Mux Bose Cygwin 6.0",
        domain = { DomainName = "Mux" },
        args = {
            "cmd.exe",
            "/c",
            "C:/cygwin64/Cygwin.bat"
        }
    })
    table.insert(config.launch_menu, {
        label = 'SSH WSL Mux Ubuntu',
        domain = { DomainName = 'SSH WSL Mux Ubuntu' }
    })
    table.insert(config.launch_menu, {
        label = 'Mux Developer Command Prompt for VS 2022 Community',
        domain = { DomainName = "Mux" },
        args = {
            'cmd.exe',
            '/k',
            'C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools/VsDevCmd.bat',
            '-startdir=none',
            '-arch=x64',
            '-host_arch=x64',
        },
    })
    table.insert(config.launch_menu, {
        label = 'Mux Developer Powershell for VS 2022 Community',
        domain = { DomainName = "Mux" },
        args = {
            'powershell.exe',
            '-NoExit',
            '-Command',
            '&{Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell 3c97223e -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',
        },
    })
    table.insert(config.launch_menu, {
        label = 'Mux Developer Command Prompt for VS 2022 Professional',
        domain = { DomainName = "Mux" },
        args = {
            'cmd.exe',
            '/k',
            'C:/Program Files/Microsoft Visual Studio/2022/Professional/Common7/Tools/VsDevCmd.bat',
            '-startdir=none',
            '-arch=x64',
            '-host_arch=x64',
        },
    })
    table.insert(config.launch_menu, {
        label = 'Mux Developer Powershell for VS 2022 Professional',
        domain = { DomainName = "Mux" },
        args = {
            'powershell.exe',
            '-NoExit',
            '-Command',
            '&{Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Professional/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell bf82c5b9 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',
        },
    })
    table.insert(config.launch_menu, {
        label = 'WSL Ubuntu',
        domain = { DomainName = 'WSL:Ubuntu' }
    })

    config.default_prog = { "nu.exe", "-i", "-l" }
else
    if MAC then
        if #wezterm.glob('/opt/homebrew/bin/zsh') ~= 0 then
            config.default_prog = { '/opt/homebrew/bin/zsh', '-l', '-i', '-c', 'if type nu &> /dev/null; then nu -l -i; else /opt/homebrew/bin/zsh -l -i; fi' }
        elseif #wezterm.glob('/usr/local/bin/zsh') ~= 0 then
            config.default_prog = { '/usr/local/bin/zsh', '-l', '-i', '-c', 'if type nu &> /dev/null; then nu -l -i; else /usr/local/bin/zsh -l -i; fi' }
        else
            config.default_prog = { '/bin/zsh', '-l', '-i', '-c', 'if type nu &> /dev/null; then nu -l -i; else /bin/zsh -l -i; fi' }
        end
    else
        config.default_prog = { '/bin/bash', '-i', '-c', 'if type nu &> /dev/null; then nu -l -i; elif type zsh &> /dev/null; then zsh -l -i; else bash -i; fi' }
    end
    table.insert(config.launch_menu, {
        label = 'local',
        domain = { DomainName = 'local' }
    })
    table.insert(config.launch_menu, {
        label = 'Mux',
        domain = { DomainName = 'Mux' }
    })
end

table.insert(config.launch_menu, {
    label = 'SSH Mux VPS',
    domain = { DomainName = 'SSH Mux VPS' }
})
table.insert(config.launch_menu, {
    label = 'SSH VPS',
    domain = { DomainName = 'SSH VPS' }
})

config.initial_rows = 48
config.initial_cols = 160

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
