-- Set <space> as the leader key.
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal.
vim.g.have_nerd_font = true

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Neovim Lua config
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish.
-- For more options, see `:help option-list`

-- Make line numbers default.
vim.opt.number = true
-- Enable mouse mode, can be useful for resizing splits for example.
vim.opt.mouse = 'a'
-- Don't show the mode, since it's already in the status line.
vim.opt.showmode = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Enable break indent.
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
-- Save undo history.
vim.opt.undofile = true

-- Case-insensitive searching unless \C or one or more capital letters are used.
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep search highlighting on so `<Esc>` can clear it explicitly.
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- Preview substitutions live, as you type.
vim.opt.inccommand = 'split'

vim.opt.termguicolors = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
-- Keep signcolumn on by default.
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'

-- Configure how new splits should be opened.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Avante works better with a global statusline and stable split behavior.
vim.opt.splitkeep = 'screen'
vim.opt.laststatus = 3

-- Show whitespace characters.
-- See `:help 'list'` and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on.
vim.opt.cursorline = true

-- Decrease update time.
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time so which-key appears sooner.
vim.opt.timeoutlen = 300

-- vim.opt.colorcolumn = "80"

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  command = 'setlocal shiftwidth=2 tabstop=2',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  command = 'setlocal shiftwidth=4 tabstop=4',
})
