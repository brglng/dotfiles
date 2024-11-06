return {
    "mrcjkb/rustaceanvim",
    init = function()
        vim.g.rustaceanvim = {
            server = {
                cmd = function()
                    if vim.fn.has('win32') then
			return { 'rust-analyzer.cmd' }
		    else
			return { 'rust-analyzer' }
		    end
	        end
	    }
        }
    end
}
