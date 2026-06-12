return {
    'saghen/blink.pairs',
    version = '*',
    dependencies = 'saghen/blink.lib',

    -- download prebuilt binaries from github releases, must be on a versioned release
    -- build = function() require('blink.pairs').download():pwait(60000) end,

    -- OR build from source
    build = function() require('blink.pairs').build():pwait(60000) end,

    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
        mappings = {
            disabled_filetypes = { 'TelescopePrompt', 'help', 'markdown', 'norg' },
        },
        highlights = {
            enabled = true,

            groups = { 'BlinkPairs' }
        }
    }
}
