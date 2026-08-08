return {
    'Bekaboo/dropbar.nvim',
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
        bar = {
            enable = function(buf, win, _)
	        if
		    not vim.api.nvim_buf_is_valid(buf)
		    or not vim.api.nvim_win_is_valid(win)
		    or vim.fn.win_gettype(win) ~= ''
		    or vim.wo[win].winbar ~= ''
		    or vim.bo[buf].ft == 'help'
		    or vim.bo[buf].ft == 'neo-tree-preview'
		    or vim.w[win].neo_tree_preview == 1
	        then
		    return false
	        end

	        local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
	        if stat and stat.size > 1024 * 1024 then
		    return false
	        end

	        return vim.bo[buf].ft == 'markdown'
		    or pcall(vim.treesitter.get_parser, buf)
		    or not vim.tbl_isempty(vim.lsp.get_clients({
		        bufnr = buf,
		        method = 'textDocument/documentSymbol',
		    }))
	    end,
        },
        sources = {
            path = {
                preview = false
            }
        }
    },
    config = function (_, opts)
        require("dropbar").setup(opts)

        local set_dropbar_colors = function()
            local WinBar = vim.api.nvim_get_hl(0, { name = "WinBar", link = false })
            local WinBarNC = vim.api.nvim_get_hl(0, { name = "WinBarNC", link = false })
            -- local Normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
            vim.api.nvim_set_hl(0, "WinBar", { fg = WinBar.fg, bg = nil, bold = true })
            vim.api.nvim_set_hl(0, "WinBarNC", { fg = WinBarNC.fg, bg = nil, bold = false })
        end
        set_dropbar_colors()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_dropbar_colors
        })
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = set_dropbar_colors
        })
    end
}
