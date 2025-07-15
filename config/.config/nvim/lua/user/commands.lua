-- custom line commands

-- lsp options
-- create a command to toggle diagnostics
vim.api.nvim_create_user_command("ToggleDiagnostics", function()
  local current_state = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current_state, underline = not current_state })
  if not current_state then
    print("Diagnostics enabled")
  else
    print("Diagnostics disabled")
  end
end, {})

-- undo persistence
vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("persist_undo", {}),
  desc = "Persist undo history",
  pattern = "*",
  callback = function()
    vim.opt.undofile = true
  end,
})

-- config
vim.api.nvim_create_user_command("Config", function()
  vim.cmd([[cd ~/.config/nvim]])
  vim.cmd("Telescope find_files")
end, {})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Hightlight selection on yank",
  pattern = "*",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- set filetype for blade files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.blade.php" },
  callback = function()
    vim.opt.filetype = "html"
  end,
})
-- remove trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("strip_trailing_whitespace", {}),
  desc = "Remove trailing whitespace on save",
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("terminal_settings", {}),
  desc = "Terminal settings",
  pattern = "*",
  callback = function()
    vim.cmd([[startinsert]])
    vim.cmd([[setlocal signcolumn=no]])
    vim.cmd([[setlocal nonumber norelativenumber]])
    vim.cmd([[setlocal foldcolumn=0]])
    -- split below the same window
    vim.cmd([[setlocal splitbelow]])
    -- set terminal size to 10 lines, **I disabeld this because it breaks lazygit inside neovim**
    -- vim.cmd([[resize 10]])
    -- open terminal in insert mode
    vim.cmd([[setlocal filetype=terminal]])
    vim.cmd([[setlocal statusline=%{get(b:,'coc_current_function','')}]])
    -- move between terminal windows
    vim.cmd([[tnoremap <buffer> <c-h> <c-\><c-n><c-w>h]])
    vim.cmd([[tnoremap <buffer> <c-j> <c-\><c-n><c-w>j]])
    vim.cmd([[tnoremap <buffer> <c-k> <c-\><c-n><c-w>k]])
    vim.cmd([[tnoremap <buffer> <c-l> <c-\><c-n><c-w>l]])
  end,
})

-- return to insert mode on buffer enter in terminals
vim.api.nvim_create_autocmd("WinEnter", {
  group = vim.api.nvim_create_augroup("terminal_return", {}),
  desc = "Return to insert mode on buffer enter in terminals",
  pattern = "term://*",
  callback = function()
    vim.cmd([[startinsert]])
  end,
})

-- set fold settings
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("fold_settings", {}),
  desc = "Set fold settings",
  pattern = "*",
  callback = function()
    vim.cmd([[setlocal foldlevel=99]])
    vim.cmd([[setlocal foldmethod=expr]])
    vim.cmd([[setlocal foldexpr=nvim_treesitter#foldexpr()]])
  end,
})

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("format_on_save", {}),
  desc = "Format on save",
  pattern =
  "*.lua, *.py, *.js, *.ts, *.json, *.css, *.scss, *.html, *.md, *.php, *.go, *.rs, *.java, *.c, *.cpp, *.h, *.sh, *.yaml, *.sql",
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- source lua files on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  callback = function()
    vim.cmd("source %")
    print("Sourced " .. vim.fn.expand("%"))
  end,
})

-- command for checking exchange rates
-- vim.api.nvim_create_user_command("Currency", function()
--   vim.cmd([[!curl -s https://api.exchangerate-api.com/v4/latest/SAR | jq .rates.KES]])
--   vim.cmd([[echo]])
--   vim.cmd([[!curl -s https://api.exchangerate-api.com/v4/latest/USD | jq .rates.KES]])
--   vim.cmd([[echo]])
-- end, {})

-- when lazygit is opened within neovim, set the size to 30 lines
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("lazygit_size", {}),
  desc = "Lazygit size",
  pattern = "*lazygit*",
  callback = function()
    vim.cmd([[resize 36]])
  end,
})

-- save macros that are triggered when entering a buffer
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("save_macros", {}),
  desc = "Save macros",
  pattern = "*",
  callback = function()
    -- update your favorite macros here
    -- make the current line in markdown into a checkbox
    vim.fn.setreg("c", "0I- [ �kb �kr�kbf]��5a j")
    -- mark as completed checkbox
    vim.fn.setreg("x", "02f ��5rx��50j")
    -- bold
    vim.fn.setreg("b", "0i**A**0")
    -- italic
    vim.fn.setreg("i", "0i*A*0")
    -- list item
    vim.fn.setreg("l", "0I- 0")
  end,
})
