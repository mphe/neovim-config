-- Device-local configuration
-- Do not commit changes into Git unless universally applicable.

local M = {}

function M.get_dashboard_shortcuts()
end


function M.get_copilot_chat_model()
    return "gpt-5.3-codex"
end

function M.get_copilot_chat_sticky_prompts()
    return {}
end

return M
