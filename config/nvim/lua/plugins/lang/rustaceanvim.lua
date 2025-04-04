return {
    "mrcjkb/rustaceanvim",
    version = '^5',
    ft = 'rust',
    cmd = { 'RustAnalyzer', 'RustLsp', "Rustc" },
    init = function ()
        local sep
        if vim.uv.os_uname().sysname == "Windows_NT" then
            sep = '\\'
        else
            sep = '/'
        end
        local cmd = vim.fn.stdpath('data') .. sep .. 'mason' .. sep .. 'bin' .. sep .. 'rust-analyzer'
        if vim.uv.os_uname().sysname == "Windows_NT" then
            cmd = cmd .. ".cmd"
        end
        vim.g.rustaceanvim = {
            server = {
                cmd = { cmd }
            },
            tools = {
                float_win_config = {}
            }
        }
        if vim.g.neovide then
            vim.g.rustaceanvim = vim.tbl_deep_extend('force', vim.g.rustaceanvim, {
                tools = {
                    float_win_config = {
                        border = "single",
                        -- winhighlight = "NormalFloat:NormalFloat,Normal:NormalFloat,FloatBorder:FloatBorder"
                        winhighlight = "NormalFloat:NormalFloat,Normal:NormalFloat,FloatBorder:FloatBorder"
                    }
                }
            })
        else
            vim.g.rustaceanvim = vim.tbl_deep_extend('force', vim.g.rustaceanvim, {
                tools = {
                    float_win_config = {
                        border = "rounded",
                        winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder"
                    }
                }
            })
        end
    end
}
