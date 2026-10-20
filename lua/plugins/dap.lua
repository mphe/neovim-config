local utils = require("utils")

local M = {}

local dap = utils.find_plugin("dap")

if not dap then
    return M
end

local is_windows = vim.fn.has("win32") == 1

-- DAP {{{
dap.adapters.codelldb = {
    type = "executable",
    -- Mason creates a codelldb.cmd in its bin folder, but this fails to properly start the DAP
    -- server and the application never launches.
    command = is_windows
        and vim.fn.expand("$MASON/packages/codelldb/extension/adapter/codelldb.exe")
        or "codelldb",
    detached = false,  -- On windows this must be false, usually
    -- options = {
    --     env = {
    --         LLDB_USE_NATIVE_PDB_READER = "1",
    --     },
    -- },
}

-- Dont't stop on all exceptions, even handled ones
-- dap.defaults.codelldb.exception_breakpoints = {}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
    {
      -- If you get an "Operation not permitted" error using this, try disabling YAMA:
      --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      name = "Attach to process",
      type = 'codelldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      args = {},
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticHint", linehl = "CursorLine" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })

dap.listeners.after.event_stopped["notify_stop"] = function(_, body)
    if body.reason == "breakpoint" or body.reason == "exception" then
        vim.notify("Breakpoint hit: " .. body.reason, vim.log.levels.INFO)
        io.write("\a")  -- bell: flashes/alerts the Neovim window
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-repl", "dap-view", "dap-view-term", "dapui_*", "dap-disasm" },
    callback = function(args)
        vim.bo[args.buf].buflisted = false
    end,
})

vim.api.nvim_create_user_command("DapSetConditionalBreakpoint", function(opts)
    if opts.args ~= "" then
        dap.set_breakpoint(opts.args)
    else
        vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
            if cond then
                dap.set_breakpoint(cond)
            end
        end)
    end
end, { nargs = "?", desc = "Set conditional breakpoint" })

-- }}}

-- DAP UI {{{
local dapui = utils.setup_plugin("dapui", {
    controls = {
        element = "repl",
        enabled = true,
    },
    element_mappings = {
        stacks = {
            open = { "o", "<2-LeftMouse>" },
            expand = "<CR>",
        },
    },
    layouts = {
        {
            elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 8,
        },
        {
            elements = {
                { id = "scopes", size = 0.30 },
                { id = "stacks", size = 0.35 },
                { id = "breakpoints", size = 0.20 },
                { id = "watches", size = 0.15 },
            },
            position = "bottom",
            size = 12,
        },
        -- {
        --     elements = { { id = "disassembly" } },
        --     position = "right",
        --     size = 0.3,
        -- },
    },
    render = {
        indent = 2,
    },
    select_window = require('window-picker').pick_window
})

if dapui then
    -- Defer to prevent a crash due to deleting a window whose winbar click event is still being processed
    local function dapui_safe_close()
        vim.defer_fn(function() pcall(dapui.close) end, 500)
    end

    dap.listeners.before.attach.dapui_config = function()
        vim.defer_fn(dapui.open, 100)
    end
    dap.listeners.before.launch.dapui_config = function()
        vim.defer_fn(dapui.open, 100)
    end
    dap.listeners.before.event_terminated.dapui_config = dapui_safe_close
    dap.listeners.before.event_exited.dapui_config = dapui_safe_close

    vim.cmd([[
        anoremenu PopUp.DAP\ Evaluate <Cmd>lua require("dapui").eval()<CR>
    ]])

    vim.api.nvim_create_user_command("DapUiOpen", function() dapui.open() end, { desc = "Open DAP UI" })
    vim.api.nvim_create_user_command("DapUiClose", function() dapui.close() end, { desc = "Close DAP UI" })
    vim.api.nvim_create_user_command("DapUiToggle", function() dapui.toggle() end, { desc = "Toggle DAP UI" })

    vim.keymap.set({ "n", "v" }, "<leader>k", function() dapui.eval() end, { desc = "DAP: Evaluate" })

    utils.setup_plugin("nvim-dap-virtual-text", {
        highlight_new_as_changed = true,
        virt_text_pos = "eol",
    })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = {
            'dap-repl', 'dapui_console', 'dapui_watches', 'dapui_stacks',
            'dapui_breakpoints', 'dapui_scopes',
        },
        callback = function(args)
            if vim.bo[args.buf].filetype == 'dapui_stacks' then
                local session = dap.session()
                local lang = session and vim.treesitter.language.get_lang(session.filetype) or nil
                if lang then
                    pcall(vim.treesitter.start, args.buf, lang)
                end
            end
        end,
    })
end
-- }}}

-- Dap View {{{
local dapview = utils.setup_plugin("dap-view", {
    virtual_text = {
        enabled = true,
        position = "eol",
    },
    auto_toggle = "open",
    winbar = {
        sections = {
            "scopes", "console", "watches", "exceptions", "breakpoints", "threads", "repl", "disassembly",
        },
        default_section = "scopes",
        controls = {
            enabled = true,
        },
    },
    keymaps = {
        base = {
            next_view = "<tab>",
            -- prev_view = "<s-tab>",
        },
    },
})

if dapview then
    -- Defer to prevent a crash due to deleting a window whose winbar click event is still being processed
    local function dapview_safe_close()
        vim.defer_fn(function() pcall(dapview.close, true) end, 500)
    end

    dap.listeners.before.event_terminated.dapview_config = dapview_safe_close
    dap.listeners.before.event_exited.dapview_config = dapview_safe_close

    vim.cmd([[
        anoremenu PopUp.DAP\ Evaluate <Cmd>DapViewHover<CR>
    ]])

    vim.keymap.set({ "n", "v" }, "<leader>k", function() dapview.hover() end, { desc = "DAP: Evaluate" })
end
-- }}}

if dapui or dapview then
    if utils.setup_plugin("dap-disasm", {
        columns = {
            "address",
            "instructionBytes",
            "instruction",
        },
        winbar = {
            labels = {
                step_into = " ",
                step_over = " ",
                step_back = " ",
            },
        },
    })
    then
        vim.api.nvim_create_user_command("DapDisasmV", "vertical DapDisasm", { desc = "Open DAP disassembly in vertical split" })
    end
end


if utils.setup_plugin("nvim-dap-repl-highlights") then
    require('nvim-treesitter').install { 'dap_repl' }
end


utils.setup_plugin("dap-info", {})


local set_exception_breakpoints = utils.find_plugin("nvim-dap-exception-breakpoints")

if set_exception_breakpoints then
    vim.api.nvim_create_user_command("DapSetExceptionBreakpointsOptions", function()
        set_exception_breakpoints()
    end, { desc = "Set exception breakpoints options" })
end

function M.save_breakpoints()
    local ok, breakpoints = pcall(require, "dap.breakpoints")

    if not ok or not breakpoints then
        return {}
    end

    local bps = {}
    local breakpoints_by_buf = breakpoints.get()

    for buf, buf_bps in pairs(breakpoints_by_buf) do
        bps[vim.api.nvim_buf_get_name(buf)] = buf_bps
    end

    return bps
end

function M.restore_breakpoints(extra_data)
    local ok, breakpoints = pcall(require, "dap.breakpoints")

    if not ok or not breakpoints then
        return
    end

    for buf_name, buf_bps in pairs(extra_data) do
        for _, bp in pairs(buf_bps) do
            local line = bp.line
            local opts = {
                condition = bp.condition,
                log_message = bp.logMessage,
                hit_condition = bp.hitCondition,
            }

            local bufnr = vim.fn.bufnr(buf_name, true)
            if vim.fn.bufloaded(bufnr) == 0 then
                vim.api.nvim_buf_call(bufnr, vim.cmd.edit)
            end

            breakpoints.set(opts, bufnr, line)
        end
    end
end

local has_run = false
dap.listeners.after.launch["smart_launch"] = function() has_run = true end
dap.listeners.after.attach["smart_launch"] = function() has_run = true end

function M.smart_launch()
    if has_run then
        vim.schedule(dap.run_last)
    else
        vim.schedule(dap.continue)
    end
end

function M.build_and_launch_or_continue()
    -- If a session is already running, F5 should just continue
    if dap.session() then
        vim.schedule(dap.continue)
        return
    end

    local overseer = utils.find_plugin("overseer")

    if overseer then
        overseer.run_task({ name = "Make" }, function(task)
            if not task then
                vim.notify("Build task failed to start", vim.log.levels.ERROR)
                return
            end

            task:subscribe("on_complete", function(_, status)
                vim.schedule(overseer.close)
                vim.defer_fn(function()
                    if status == "SUCCESS" then
                        M.smart_launch()
                    end
                end, 100)
            end)
        end)
    else
        M.smart_launch()
    end
end

return M
