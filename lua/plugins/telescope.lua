local telescope_actions = require("telescope.actions")
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
                    -- Yank the selected path (https://github.com/nvim-telescope/telescope-file-browser.nvim/issues/327)
                    ["<C-y>"] = function(prompt_bufnr)
                        local entry = require("telescope.actions.state").get_selected_entry()
                        -- local relpath = entry[1]
                        local cb_opts = vim.opt.clipboard:get()
                        if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", entry.path) end
                        if vim.tbl_contains(cb_opts, "unnamedplus") then
                            vim.fn.setreg("+", entry.path)
                        end
                        vim.fn.setreg("", entry.path)
                        telescope_actions.close(prompt_bufnr)
                    end,
                },
            },
        },
    },
}

vim.cmd([[hi! link TelescopeBorder FloatBorder]])
