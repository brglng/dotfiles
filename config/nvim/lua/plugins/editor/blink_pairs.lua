return {
    'saghen/blink.pairs',
    version = '*',
    dependencies = 'saghen/blink.lib',
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
        mappings = {
            disabled_filetypes = { 'TelescopePrompt', 'help', 'markdown', 'norg' },
        },
        highlights = {
            enabled = false,
        }
    }
}
