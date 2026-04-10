local telescope_actions = require("telescope.actions")


-- Yank the selected path in file picker (https://github.com/nvim-telescope/telescope-file-browser.nvim/issues/327)
local function get_selected_path()
    return require("telescope.actions.state").get_selected_entry().path
end

local function yank(text)
    local cb_opts = vim.opt.clipboard:get()
    if vim.tbl_contains(cb_opts, "unnamed") then
        vim.fn.setreg("*", text)
    end
    if vim.tbl_contains(cb_opts, "unnamedplus") then
        vim.fn.setreg("+", text)
    end
    vim.fn.setreg("", text)
end


local function open_file_path_yank_picker(opts)
    opts = opts or {}
    opts.insert = opts.insert or false
    opts.switch_to_insert = opts.switch_to_insert or false
    opts.close = opts.close or true
    opts.yank = opts.yank or true

    require("telescope.builtin").find_files({
        attach_mappings = function(_, map)
            map("i", "<CR>", function(prompt_bufnr)
                local path = get_selected_path()

                if opts.yank then
                    yank(path)
                end

                if opts.insert then
                    vim.schedule(function()
                        vim.api.nvim_put({ path }, "c", true, true)
                    end)
                end

                if opts.switch_to_insert then
                    vim.schedule(function()
                        vim.cmd('startinsert!')
                    end)
                end

                if opts.close then
                    telescope_actions.close(prompt_bufnr)
                end
            end)
            return true
        end,
    })
end


require("telescope").setup{
    defaults = {
        -- preview = false,
        mappings = {
            i = {
                ["<esc>"] = telescope_actions.close,
                ["<C-j>"] = {
                    telescope_actions.move_selection_next,
                    type = "action",
                    opts = { nowait = true, silent = true },
                },
                ["<C-k>"] = {
                    telescope_actions.move_selection_previous,
                    type = "action",
                    opts = { nowait = true, silent = true },
                },
            },
            n = {
                ["v"] = telescope_actions.select_vertical,
                ["s"] = telescope_actions.select_horizontal,
            },
        },
        file_ignore_patterns = {
            "%.vs[\\/]",
            "%.godot[\\/]",
            "%.import[\\/]",
            "%.git[\\/]",
            "%.hg[\\/]",
            "%.svn[\\/]",
            "%.clangd[\\/]",
            "%.ccls-cache[\\/]",
            "%.tmp[\\/]",
            "%.mypy_cache[\\/]",
            "%.cache[\\/]",
            "node_modules[\\/]",
            "build[\\/]",
            "out[\\/]",
            "%.exe",
            "%.so",
            "%.dll",
            "%.pyc",
            "%.o",
            "%.a",
            "%.obj",
            "%.uid",
        },
    },
    pickers = {
        lsp_references = {
            initial_mode = "normal",
            include_current_line = true,
            jump_type = "never",
        },
        lsp_definitions = {
            initial_mode = "normal",
        },
        find_files = {
            mappings = {
                i = {
                    ["<C-y>"] = function() yank(get_selected_path()) end,
                },
            },
        },
    },
}


vim.keymap.set("n", "<C-t>", open_file_path_yank_picker, { desc = "Pick file and yank path" })
vim.keymap.set("i", "<C-t>", function() open_file_path_yank_picker({ insert = true, switch_to_insert = true }) end, { desc = "Pick file and yank path" })


vim.cmd([[hi! link TelescopeBorder FloatBorder]])
