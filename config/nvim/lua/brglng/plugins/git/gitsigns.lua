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
                    return "solid"
                else
                    return "rounded"
                end
            end)(),
            -- border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
            -- focusable = true,
        }
    },
    config = function(_, opts)
        require("gitsigns").setup(opts)
        local orig_popup_create = require("gitsigns.popup").create

        --- @param lines_spec Gitsigns.LineSpec[]
        --- @param opts_ vim.api.keyset.win_config
        --- @param id? string
        --- @return integer winid, integer bufnr
        require("gitsigns.popup").create = function(lines_spec, opts_, id)
            local winid, bufnr = orig_popup_create(lines_spec, opts_, id)
            vim.api.nvim_set_option_value("winhighlight", "Normal:GitSignsPopupNormal,NormalFloat:GitSignsPopupNormal,FloatBorder:GitSignsPopupBorder", { win = winid })
            return winid, bufnr
        end

        require("brglng.hl").transform_tbl(function()
            if vim.g.neovide then
                return {
                    GitSignsPopupNormal = { link = "NormalFloat" },
                    GitSignsPopupBorder = { link = "NormalFloat" },
                }
            else
                return {
                    GitSignsPopupNormal = { fg = "Normal.fg", bg = "Normal.bg" },
                    GitSignsPopupBorder = { fg = "FloatBorder.fg,Normal.fg", bg = "Normal.bg" },
                }
            end
        end)
    end,
    keys = {
        { "<Leader>hs", mode = "n", function() require("gitsigns").stage_hunk() end, desc = "Stage/Unstage Hunk" },
        { "<Leader>hr", mode = "n", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
        { "<Leader>hS", mode = "n", function() require("gitsigns").stage_buffer() end, desc = "Stage Buffer" },
        { "<Leader>hR", mode = "n", function() require("gitsigns").reset_buffer() end, desc = "Reset Buffer" },
        { "<Leader>hp", mode = "n", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },
        { "<Leader>hi", mode = "n", function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Hunk Inline" },
        { "<Leader>hb", mode = "n", function() require("gitsigns").blame_line() end, desc = "Blame Line" },
        { "<Leader>hB", mode = "n", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle Blame for Current Line" },
        { "<Leader>hd", mode = "n", function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Hunk Inline" }
    }
}
