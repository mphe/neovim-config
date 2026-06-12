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
    vim.keymap.set("n", "<F9>", function()
        if vim.g.config_use_nvimlsp == 1 then
            require("lsp-endhints").toggle()
            require("custom.inlayhints").toggle()
        end
    end)
end
