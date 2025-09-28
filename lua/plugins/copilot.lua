require("copilot").setup()

function copilot_show()
    require("copilot.suggestion").next()
end

function copilot_cancel()
    if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").dismiss()
    end
end

function copilot_accept()
    if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
        copilot_cancel()
        return true
    end

    return false
end

vim.api.nvim_create_autocmd("InsertLeave", {
    command = "silent! lua copilot_cancel()",
    group = vim.api.nvim_create_augroup("custom_copilot_trigger", { clear = true }),
})

vim.api.nvim_set_keymap('i', '<C-c>', '<cmd>lua copilot_show()<CR>', { noremap = true, silent = true })

-- require('copilot-client').setup {
--   mapping = {
--     accept = '<CR>',
--     -- Next and previos suggestions to be added
--     -- suggest_next = '<C-n>',
--     -- suggest_prev = '<C-p>',
--   },
-- }

-- Create a keymap that triggers the suggestion.
-- vim.api.nvim_set_keymap('i', '<C-c>', '<cmd>lua require("copilot-client").suggest()<CR>', { noremap = true, silent = true })
