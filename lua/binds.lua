local utils = require("utils")

if utils.has_plugin("telescope") then
    vim.keymap.set('n', '<F2>', '<cmd>Telescope commands<CR>', { noremap = true, silent = true })
end

if utils.has_plugin("CopilotChat") then
    vim.keymap.set('n', '<F3>', '<cmd>CopilotChatToggle<CR>', { noremap = true, silent = true })
end

if utils.has_plugin("codecompanion") then
    vim.keymap.set('n', '<F3>', '<cmd>CodeCompanionChat Toggle<CR>', { noremap = true, silent = true })
end

-- Toggle inlay hint visibility: all on and inline / only type hints and at eol
if utils.has_plugin("lsp-endhints") then
    vim.keymap.set("n", "<F8>", function()
        if vim.g.config_use_nvimlsp == 1 then
            require("lsp-endhints").toggle()
            require("custom.inlayhints").toggle()
        end
    end)
end


if utils.has_plugin("overseer") then
    vim.api.nvim_set_keymap("n", "<F4>", ":OverseerRun<CR>", { noremap = true, silent = true })
end

local dap = utils.find_plugin("dap")

if dap then
    vim.keymap.set("n", "<F9>", function() dap.toggle_breakpoint() end, { desc = "DAP: Toggle breakpoint" })
    vim.keymap.set("n", "<S-F9>", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
    end, { desc = "DAP: Conditional breakpoint" })
    vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "DAP: Step over" })
    vim.keymap.set("n", "<C-F10>", function() dap.run_to_cursor() end, { desc = "DAP: Run to cursor" })
    vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "DAP: Step into" })
    vim.keymap.set("n", "<S-F11>", function() dap.step_out() end, { desc = "DAP: Step out" })
    vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "DAP: Step out" })
end
