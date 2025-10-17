vim.g.barbar_auto_setup = false
require'bufferline'.setup {
  exclude_ft = { "qf" },
  focus_on_close = 'previous',
  insert_at_end = true,
  maximum_padding = 2,
  minimum_padding = 1,
  maximum_length = 30,

  icons = {
    preset = "powerline",
    -- preset = "slanted",
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {enabled = false, icon = vim.g.config_icon_error},
      [vim.diagnostic.severity.WARN] = {enabled = false, icon = vim.g.config_icon_warning},
      [vim.diagnostic.severity.INFO] = {enabled = false, icon = vim.g.config_icon_info},
      [vim.diagnostic.severity.HINT] = {enabled = false, icon = vim.g.config_icon_hint},
    },
    gitsigns = { enabled = false },

    button = '',
    modified = {button = '●'},
    pinned = {button = ''},

    separator = { left = vim.g.config_separator_left, right = vim.g.config_separator_left },
    inactive = { separator = { left = vim.g.config_separator_left, right = vim.g.config_separator_left } },
  },
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
