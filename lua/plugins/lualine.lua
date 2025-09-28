local custom_theme

if vim.g.colors_name == "solarized" then
    custom_theme = require'lualine.themes.solarized_dark'
    custom_theme.command = { a = custom_theme.insert.a }
    custom_theme.insert = { a = custom_theme.normal.a }
    custom_theme.normal.a = { bg = custom_theme.normal.b.bg, fg = custom_theme.normal.b.fg, gui = "bold" }
    custom_theme.normal.b = { fg = "#6c71c4", bg = custom_theme.normal.c.bg, }
    custom_theme.inactive.b = custom_theme.normal.b
    -- custom_theme.normal.b = { bg = custom_theme.normal.c.bg, fg = "#b58900" }
end

require("lualine").setup {
    options = {
        theme = custom_theme or "auto",
        section_separators = { left = vim.g.config_separator_left, right = vim.g.config_separator_right },
        component_separators = { left = vim.g.config_subseparator_left, right = vim.g.config_subseparator_right },
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'filename'},
        lualine_c = {'branch'},
        lualine_x = {'diagnostics', 'encoding', 'fileformat', 'filetype'},
        lualine_y = {
            { 'lsp_status', ignore_lsp = {"copilot"} },
            "searchcount"
        },
        lualine_z = {'progress', 'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {'filename'},
        lualine_c = {},
        lualine_x = {'diagnostics'},
        lualine_y = {},
        lualine_z = {'progress', 'location'}
    },
}
