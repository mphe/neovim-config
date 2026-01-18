local custom_theme

if vim.g.colors_name == "solarized" then
    custom_theme = require'lualine.themes.solarized_dark'
    custom_theme.command = { a = custom_theme.insert.a }
    custom_theme.insert = { a = custom_theme.normal.a }
    custom_theme.normal.a = { bg = custom_theme.normal.b.bg, fg = custom_theme.normal.b.fg, gui = "bold" }
    custom_theme.normal.b = { fg = "#6c71c4", bg = custom_theme.normal.c.bg, }
    custom_theme.inactive.b = custom_theme.normal.b
end

local diagnostic_spacing = " "
local diagnostics_component = {
    'diagnostics',
    symbols = {
        error = vim.g.config_icon_error .. diagnostic_spacing,
        warn = vim.g.config_icon_warning .. diagnostic_spacing,
        info = vim.g.config_icon_info .. diagnostic_spacing,
        hint = vim.g.config_icon_hint .. diagnostic_spacing,
    },
    diagnostics_color = {
        error = 'DiagnosticSignError',
        warn  = 'DiagnosticSignWarn',
        info  = 'DiagnosticSignInfo',
        hint  = 'DiagnosticSignHint',
    },
}

local lspstatus_component = { 'lsp_status', ignore_lsp = {"copilot"} }

local file_icon_component = {
    "filetype",
    icon_only = true,
    colored = false,
    padding = 0,
}

local filename_component = {
    "filename",
    path = 1,  -- relative path
    -- color = "Comment",
}

local filename_component_short = {
    "filename",
    path = 1,  -- relative path
    padding = 0,
    shorting_target = 80,
    color = "Comment",
}

local breadcrumbs = {
    function()
        local breadcrumbs = require('lspsaga.symbol.winbar').get_bar()
        if breadcrumbs and breadcrumbs ~= "" then
            return "> " .. breadcrumbs
        end
        return ""
    end,
}

local fileformat = {
    "fileformat",
    symbols = {
        unix = "",
    }
}

local function get_encoding()
    local enc = vim.bo.fileencoding
    if enc == "utf-8" then
        return ""
    end
    return enc
end

local winbar = {
    lualine_c = { file_icon_component, filename_component_short, breadcrumbs, },
    lualine_x = { diagnostics_component, get_encoding, fileformat, 'filetype', },
}

require("lualine").setup {
    options = {
        theme = custom_theme or "auto",
        section_separators = { left = vim.g.config_separator_left, right = vim.g.config_separator_right },
        component_separators = { left = vim.g.config_subseparator_left, right = vim.g.config_subseparator_right },
        globalstatus = true,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {filename_component},
        lualine_c = {},
        lualine_x = { "searchcount", { "branch", color = "Comment"} },
        lualine_y = { lspstatus_component, },
        lualine_z = {'progress', 'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {filename_component},
        lualine_c = {},
        lualine_x = {diagnostics_component},
        lualine_y = {},
        lualine_z = {'progress', 'location'}
    },
    winbar = winbar,
    inactive_winbar = winbar,
}
