local utils = require("utils")

utils.setup_plugin("trouble", {
    focus = true,
    restore = true,
    auto_jump = false,
    auto_refresh = false,
    warn_no_results = false,
    win = {
        size = { height = 15 },
        minimal = false,
        wo = {
            number = false,
            signcolumn = "no",
            winfixheight = true,
        }
    },
    preview = {
        type = "split",
        relative = "win",
        position = "right",
        size = { width = 0.5, },
        scratch = false,
        minimal = false,
    },
    keys = {
        ["<esc>"] = "close",
        ["<cr>"] = "jump_close",
        o = "jump",
    },
    modes = {
        lsp_base = {
            auto_jump = false,
            win = {
                minimal = false,
                size = { height = 30 },
            },
            params = {
                include_current = true,
            },
        },
    },
})

if utils.has_plugin("trouble") then
    vim.api.nvim_create_user_command("Diagnostics", "Trouble diagnostics", {})

    -- Automatically open Trouble quickfix and make severity chars in qflist uppercase so
    -- trouble.nvim displays diagnostic icons
    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        callback = function()
            local qflist = vim.fn.getqflist()
            for _, entry in ipairs(qflist) do
                if entry.type ~= "" then
                    entry.type = entry.type:upper()
                end
            end
            vim.fn.setqflist(qflist, "r")
            vim.cmd([[Trouble qflist open]])
        end,
    })
end
