local M = {}

local config = {
    enabled = true,
    kinds_whitelist = {
        1,  -- type hints
    },
}

local inlayHintHandlerOriginal = vim.lsp.handlers["textDocument/inlayHint"]


local function inlayHintHandlerCustom(err, result, ctx, cfg)
    if config.enabled then
        local filtered_result = vim.iter(result):filter(function(hint)
            return config.kinds_whitelist[hint.kind] ~= nil
        end)
        inlayHintHandlerOriginal(err, filtered_result:totable(), ctx, cfg)
    else
        inlayHintHandlerOriginal(err, result, ctx, cfg)
    end
end


local function attach()
    local currentHandler = vim.lsp.handlers["textDocument/inlayHint"]

    if currentHandler ~= inlayHintHandlerCustom then
        inlayHintHandlerOriginal = currentHandler
        vim.lsp.handlers["textDocument/inlayHint"] = inlayHintHandlerCustom
        vim.lsp.inlay_hint.enable(false)
        vim.lsp.inlay_hint.enable(true)
    end
end


function M.enable()
    config.enabled = true
    attach()
end


function M.disable()
    config.enabled = false
end


function M.toggle()
    config.enabled = not config.enabled
    attach()
end


function M.setup(_)
    attach()
end


attach()

vim.api.nvim_create_user_command("InlayHintsFilterToggle", M.toggle, {})
vim.api.nvim_create_user_command("InlayHintsFilterDisable", M.disable, {})
vim.api.nvim_create_user_command("InlayHintsFilterEnable", M.enable, {})

return M
