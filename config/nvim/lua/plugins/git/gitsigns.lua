return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']h', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, { expr = true })

            map('n', '[h', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, { expr = true })

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
        preview_config = {
            border = (function()
                if vim.g.neovide then
                    return {
                        { " ", "NormalFloat" },
                        { " ", "NormalFloat" },
                    }
                else
                    return "rounded"
                end
            end)(),
            -- border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
            -- focusable = true,
        }
    },
    keys = {
        { "<Leader>hs", mode = "n", function() require("gitsigns").stage_hunk() end, desc = "Stage/Unstage Hunk" },
        { "<Leader>hr", mode = "n", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
        { "<Leader>hS", mode = "n", function() require("gitsigns").stage_buffer() end, desc = "Stage Buffer" },
        { "<Leader>hR", mode = "n", function() require("gitsigns").reset_buffer() end, desc = "Reset Buffer" },
        { "<Leader>hp", mode = "n", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },
        { "<Leader>hb", mode = "n", function() require("gitsigns").blame_line() end, desc = "Blame Line" },
        { "<Leader>hB", mode = "n", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle Blame for Current Line" },
        { "<Leader>hd", mode = "n", function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Hunk Inline" }
    }
}
