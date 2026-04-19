local utils = require("utils")
local localconfig = require("localconfig")

utils.setup_plugin("copilot", {})

function CopilotSuggestShow()
    require("copilot.suggestion").next()
end

function CopilotSuggestCancel()
    if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").dismiss()
    end
end

function CopilotSuggestAccept()
    if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
        CopilotSuggestCancel()
        return true
    end

    return false
end

vim.api.nvim_create_autocmd("InsertLeave", {
    command = "silent! lua CopilotSuggestCancel()",
    group = vim.api.nvim_create_augroup("custom_copilot_trigger", { clear = true }),
})

vim.api.nvim_set_keymap('i', '<C-c>', '<cmd>lua CopilotSuggestShow()<CR>', { noremap = true, silent = true })

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


utils.setup_plugin("mcphub", {
    extensions = {
        copilotchat = {
            enabled = true,
            convert_tools_to_functions = true,     -- Convert MCP tools to CopilotChat functions
            convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions  
            add_mcp_prefix = false,                -- Add "mcp_" prefix to function names
        }
    }
})


utils.setup_plugin("CopilotChat", {
    model = localconfig.get_copilot_chat_model(),
    trusted_tools = { "file", "glob", "grep", },
    auto_insert_mode = false,
    chat_autocomplete = false,  -- handled by blink-cmp-copilot-chat
    mappings = {
        -- jump_to_diff = "<leader>gj",
        -- accept_diff = "<leader><c-y>",
        jump_to_diff = "",
        accept_diff = "",
        reset = "",
    },
    sticky = localconfig.get_copilot_chat_sticky_prompts(),
    resources = { "selection", "buffer" },
    show_help = false,
    show_folds = false,
})


if utils.has_plugin("CopilotChat") then
    vim.keymap.set('n', '<F3>', '<cmd>CopilotChatToggle<CR>', { noremap = true, silent = true })

    -- vim.api.nvim_create_autocmd('FileType', {
    --     pattern = 'copilot-chat',
    --     callback = function()
    --         vim.opt_local.concealcursor = 'nv'
    --     end,
    -- })
end


utils.setup_plugin("codecompanion", {
    interactions = {
        chat = {
            adapter = "copilot",
            model = localconfig.get_copilot_chat_model(),
            editor_context = {
                ["buffer"] = {
                    opts = {
                        -- Always sync the buffer by sharing its "diff"
                        -- Or choose "all" to share the entire buffer
                        default_params = "diff",
                    },
                },
            },
        },
        inline = {
            adapter = "copilot",
            model = localconfig.get_copilot_chat_model(),
        },
        cmd = {
            adapter = "copilot",
            model = localconfig.get_copilot_chat_model(),
        }
    },
    extensions = {
        history = {
            enabled = true,
            opts = {
                auto_generate_title = false,
            }
        }
    }
})

if utils.has_plugin("codecompanion") then
    vim.keymap.set('n', '<F3>', '<cmd>CodeCompanionChat Toggle<CR>', { noremap = true, silent = true })
end
