vim.g.barbar_auto_setup = false
require'bufferline'.setup {
  -- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  exclude_ft = { "qf" },
  -- exclude_name = {'package.json'},

  -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
  -- Valid options are 'left' (the default) and 'right'
  focus_on_close = 'previous',

  -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
  hide = {extensions = false, inactive = false},

  -- Disable highlighting alternate buffers
  highlight_alternate = false,

  -- Disable highlighting file icons in inactive buffers
  highlight_inactive_file_icons = false,

  -- Enable highlighting visible buffers
  highlight_visible = true,

  icons = {
    preset = "powerline",
    -- preset = "slanted",
    -- Configure the base icons on the bufferline.
    buffer_index = false,
    buffer_number = false,
    button = '',
    -- Enables / disables diagnostic symbols
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {enabled = false, icon = vim.g.config_icon_error},
      [vim.diagnostic.severity.WARN] = {enabled = false, icon = vim.g.config_icon_warning},
      [vim.diagnostic.severity.INFO] = {enabled = false, icon = vim.g.config_icon_info},
      [vim.diagnostic.severity.HINT] = {enabled = false, icon = vim.g.config_icon_hint},
    },
    filetype = {
      -- Sets the icon's highlight group.
      -- If false, will use nvim-web-devicons colors
      custom_colors = false,

      -- Requires `nvim-web-devicons` if `true`
      enabled = true,
    },

    -- Configure the icons on the bufferline when modified or pinned.
    -- Supports all the base icon options.
    modified = {button = '●'},
    pinned = {button = ''},

    gitsigns = { enabled = false },

    separator = { left = vim.g.config_separator_left, right = vim.g.config_separator_left },
    inactive = { separator = { left = vim.g.config_separator_left, right = vim.g.config_separator_left } },
    -- separator = {left = '', right = ''},
    -- inactive = {separator = {left = '', right = ''}, button = '×'},

    -- separator = {left = '', right = ' '},
    -- inactive = {separator = {left = '', right = ' '}, button = '×'},
    -- inactive = {separator = {left = '🭛', right = '🭦'}, button = '×'},
    -- separator = {left = '🭛', right = '🭦'},
    -- separator = {left = '▎', right = ''},
    -- separator = {left = '', right = ''},
    -- inactive = {separator = {left = '', right = ''}, button = '×'},
    -- separator = {left = '', right = " \u{e0ba}"},
    -- inactive = {separator = {left = '', right = '\u{e0bd} '}, button = '×'},
    -- inactive = {separator = {left = '', right = ''}, button = '×'},
    -- separator = {left = '', right = ''},


    -- Configure the icons on the bufferline based on the visibility of a buffer.
    -- Supports all the base icon options, plus `modified` and `pinned`.
    -- alternate = {filetype = {enabled = false}},
    -- current = {buffer_index = false},
    -- inactive = {button = '×'},
    -- visible = {modified = {buffer_number = false}},
  },

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = true,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 2,

  -- Sets the minimum padding width with which to surround each tab
  minimum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}

-- Aliases for muscle memory
vim.cmd [[
  cnoreabbrev bf BufferFirst
  cnoreabbrev bl BufferLast
  cnoreabbrev bd BufferClose
]]

-- Move to previous/next
vim.keymap.set("n", "<leader>bp", "<Cmd>BufferPrevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>bn", "<Cmd>BufferNext<CR>", { silent = true })
-- Re-order to previous/next
vim.keymap.set("n", "<leader>b<", "<Cmd>BufferMovePrevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>b>", "<Cmd>BufferMoveNext<CR>", { silent = true })
-- Goto buffer in position...
vim.keymap.set("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", { silent = true })
vim.keymap.set("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", { silent = true })
vim.keymap.set("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", { silent = true })
vim.keymap.set("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", { silent = true })
vim.keymap.set("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", { silent = true })
vim.keymap.set("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", { silent = true })
vim.keymap.set("n", "<leader>7", "<Cmd>BufferGoto 7<CR>", { silent = true })
vim.keymap.set("n", "<leader>8", "<Cmd>BufferGoto 8<CR>", { silent = true })
vim.keymap.set("n", "<leader>9", "<Cmd>BufferGoto 9<CR>", { silent = true })
vim.keymap.set("n", "<leader>0", "<Cmd>BufferLast<CR>", { silent = true })
vim.keymap.set("n", "<leader>bL", "<Cmd>BufferLast<CR>", { silent = true })
vim.keymap.set("n", "<leader>bF", "<Cmd>BufferFirst<CR>", { silent = true })
-- Pin/unpin buffer
-- vim.keymap.set("n", "<leader>p", "<Cmd>BufferPin<CR>", { silent = true })
-- Close buffer
vim.keymap.set("n", "<leader>bd", "<Cmd>BufferClose<CR>", { silent = true })
-- Wipeout buffer
--                          :BufferWipeout
-- Close commands
--                          :BufferCloseAllButCurrent
--                          :BufferCloseAllButPinned
--                          :BufferCloseAllButCurrentOrPinned
--                          :BufferCloseBuffersLeft
--                          :BufferCloseBuffersRight
-- Magic buffer-picking mode
vim.keymap.set("n", "<leader>B", "<Cmd>BufferPick<CR>", { silent = true })
-- Sort automatically by...
-- nnoremap <silent> <Space>bb <Cmd>BufferOrderByBufferNumber<CR>
-- nnoremap <silent> <Space>bd <Cmd>BufferOrderByDirectory<CR>
-- nnoremap <silent> <Space>bl <Cmd>BufferOrderByLanguage<CR>
-- nnoremap <silent> <Space>bw <Cmd>BufferOrderByWindowNumber<CR>
--
-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
