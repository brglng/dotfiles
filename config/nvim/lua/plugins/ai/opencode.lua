return {
    "nickjvandyke/opencode.nvim",
    version = "*",
    init = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {
            lsp = {
                enabled = true,
            }
        }
    end,
    config = function(_, opts)
        -- Handle `opencode` events
        vim.api.nvim_create_autocmd("User", {
            pattern = "OpencodeEvent:*", -- Optionally filter event types
            callback = function(args)
                ---@type opencode.cli.client.Event
                local event = args.data.event
                ---@type number
                local port = args.data.port

                -- See the available event types and their properties
                vim.notify(vim.inspect(event))
                -- Do something useful
                if event.type == "session.idle" then
                    vim.notify("`opencode` finished responding")
                end
            end,
        })
    end,
    keys = {
        { "<Leader>oa", mode = { "n", "x" }, function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Ask OpenCode…" },
        { "<Leader>ox", mode = { "n", "x" }, function() require("opencode").select() end, desc = "Execute OpenCode action…" },
        { "<Leader>oo", mode = { "n", "t" }, function() require("opencode").toggle() end, desc = "Toggle OpenCode" },
        { "<Leader>or", mode = { "n", "x" }, function() return require("opencode").operator("@this ") end, desc = "Add range to OpenCode", expr = true },
        { "<Leader>ol", mode = "n", function() return require("opencode").operator("@this ") .. "_" end, desc = "Add line to OpenCode", expr = true },
        { "<S-C-u>", mode = "n", function() require("opencode").command("session.half.page.up") end, desc = "Scroll OpenCode up" },
        { "<S-C-d>", mode = "n", function() require("opencode").command("session.half.page.down") end, desc = "Scroll OpenCode down" },
    },
}
