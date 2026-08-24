local M = {}

local theme_dir = vim.fn.expand("~/.local/state/omarchy/current/theme")
local colors_file = theme_dir .. "/colors.toml"

-- Parse TOML-like key = "value" format (handles omarchy's simple TOML)
local function parse_colors(content)
  local colors = {}
  for line in content:gmatch("[^\r\n]+") do
    local key, value = line:match('^([%w_]+)%s*=%s*"([^"]*)"')
    if key and value then
      colors[key] = value
    end
  end
  return colors
end

-- Map omarchy color names to nvim highlight groups
local function apply_colors(colors)
  local hl = vim.api.nvim_set_hl

  -- Compute derived colors
  local bg = colors.background or "#1e1e2e"
  local fg = colors.foreground or "#cdd6f4"
  local accent = colors.accent or colors.blue or "#89b4fa"
  local sel_bg = colors.selection or colors.selection_background or "#45475a"
  local muted = colors.muted or colors.color8 or "#585b70"

  -- Semantic color mapping (prefer named colors, fallback to ANSI)
  local red = colors.red or colors.color1 or colors.color9 or "#f38ba8"
  local green = colors.green or colors.color2 or colors.color10 or "#a6e3a1"
  local yellow = colors.yellow or colors.color3 or colors.color11 or "#f9e2af"
  local blue = colors.blue or colors.color4 or colors.color12 or "#89b4fa"
  local magenta = colors.magenta or colors.color5 or colors.color13 or "#f5c2e7"
  local cyan = colors.cyan or colors.color6 or colors.color14 or "#94e2d5"
  local orange = colors.orange or colors.brown or colors.color7 or "#fab387"

  local dark_bg = colors.dark_background or colors.darker_background or bg
  local light_fg = colors.light_foreground or colors.bright_foreground or fg

  -- Editor UI
  hl(0, "Normal", { fg = fg, bg = bg })
  hl(0, "NormalFloat", { fg = fg, bg = dark_bg })
  hl(0, "NormalNC", { fg = fg, bg = bg })
  hl(0, "FloatBorder", { fg = accent, bg = dark_bg })
  hl(0, "FloatTitle", { fg = accent, bg = dark_bg, bold = true })

  -- Cursor
  hl(0, "Cursor", { fg = bg, bg = fg })
  hl(0, "CursorLine", { bg = dark_bg })
  hl(0, "CursorColumn", { bg = dark_bg })

  -- Line numbers
  hl(0, "LineNr", { fg = muted, bg = bg })
  hl(0, "CursorLineNr", { fg = accent, bg = dark_bg, bold = true })

  -- Selection
  hl(0, "Visual", { bg = sel_bg })
  hl(0, "VisualNOS", { bg = sel_bg })

  -- Search
  hl(0, "Search", { fg = bg, bg = yellow })
  hl(0, "IncSearch", { fg = bg, bg = orange })

  -- Statusline
  hl(0, "StatusLine", { fg = fg, bg = dark_bg })
  hl(0, "StatusLineNC", { fg = muted, bg = dark_bg })

  -- Tabs / Bufferline
  hl(0, "TabLine", { fg = muted, bg = dark_bg })
  hl(0, "TabLineFill", { bg = dark_bg })
  hl(0, "TabLineSel", { fg = fg, bg = bg, bold = true })

  -- Folds
  hl(0, "FoldColumn", { fg = muted, bg = bg })
  hl(0, "Folded", { fg = muted, bg = dark_bg })

  -- Diagnostics
  hl(0, "DiagnosticError", { fg = red })
  hl(0, "DiagnosticWarn", { fg = yellow })
  hl(0, "DiagnosticInfo", { fg = blue })
  hl(0, "DiagnosticHint", { fg = cyan })
  hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = red })
  hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = yellow })
  hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = blue })
  hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = cyan })

  -- Git signs
  hl(0, "GitSignsAdd", { fg = green })
  hl(0, "GitSignsChange", { fg = yellow })
  hl(0, "GitSignsDelete", { fg = red })

  -- Diff
  hl(0, "DiffAdd", { fg = green, bg = dark_bg })
  hl(0, "DiffChange", { fg = yellow, bg = dark_bg })
  hl(0, "DiffDelete", { fg = red, bg = dark_bg })

  -- Telescope
  hl(0, "TelescopeBorder", { fg = accent })
  hl(0, "TelescopePromptBorder", { fg = accent })
  hl(0, "TelescopeResultsBorder", { fg = accent })
  hl(0, "TelescopePreviewBorder", { fg = accent })
  hl(0, "TelescopeSelection", { bg = sel_bg })
  hl(0, "TelescopeMatching", { fg = accent, bold = true })

  -- WhichKey
  hl(0, "WhichKey", { fg = accent })
  hl(0, "WhichKeyGroup", { fg = blue })
  hl(0, "WhichKeyDesc", { fg = fg })
  hl(0, "WhichKeySeparator", { fg = muted })
  hl(0, "WhichKeyFloat", { bg = dark_bg })

  -- Lazy
  hl(0, "LazyButton", { bg = dark_bg })
  hl(0, "LazyButtonActive", { bg = sel_bg })

  -- Treesitter
  hl(0, "@variable", { fg = fg })
  hl(0, "@function", { fg = blue })
  hl(0, "@keyword", { fg = magenta })
  hl(0, "@string", { fg = green })
  hl(0, "@number", { fg = orange })
  hl(0, "@boolean", { fg = orange })
  hl(0, "@comment", { fg = muted, italic = true })
  hl(0, "@type", { fg = yellow })
  hl(0, "@constant", { fg = orange })
  hl(0, "@parameter", { fg = red })
  hl(0, "@field", { fg = fg })
  hl(0, "@property", { fg = fg })
  hl(0, "@constructor", { fg = blue })
  hl(0, "@operator", { fg = cyan })

  -- Links
  hl(0, "WinSeparator", { fg = muted })
  hl(0, "Pmenu", { fg = fg, bg = dark_bg })
  hl(0, "PmenuSel", { bg = sel_bg })
  hl(0, "QuickFixLine", { bg = sel_bg })
  hl(0, "Substitute", { fg = bg, bg = red })
  hl(0, "Whitespace", { fg = muted })

  -- Highlight others
  hl(0, "HighlightedyankRegion", { bg = sel_bg })

  -- Sign column
  hl(0, "SignColumn", { fg = muted, bg = bg })

  -- Title
  hl(0, "Title", { fg = accent, bold = true })

  -- Error / Warning / Info
  hl(0, "ErrorMsg", { fg = red, bg = bg })
  hl(0, "WarningMsg", { fg = yellow, bg = bg })

  -- Mode
  hl(0, "MoreMsg", { fg = green, bold = true })
  hl(0, "Question", { fg = green, bold = true })

  -- Conceal
  hl(0, "Conceal", { fg = muted })

  -- Spell
  hl(0, "SpellBad", { undercurl = true, sp = red })
  hl(0, "SpellCap", { undercurl = true, sp = blue })
  hl(0, "SpellLocal", { undercurl = true, sp = cyan })
  hl(0, "SpellRare", { undercurl = true, sp = magenta })

  -- i’ll hook for lualine / bufferline to pick up
  -- Store colors in a global for other plugins
  vim.g.omarchy_colors = {
    bg = bg,
    fg = fg,
    accent = accent,
    red = red,
    green = green,
    yellow = yellow,
    blue = blue,
    magenta = magenta,
    cyan = cyan,
    orange = orange,
    dark_bg = dark_bg,
    muted = muted,
  }
end

function M.apply()
  local file = io.open(colors_file, "r")
  if not file then
    return false
  end
  local content = file:read("*a")
  file:close()

  local colors = parse_colors(content)
  if vim.tbl_isempty(colors) then
    return false
  end

  apply_colors(colors)
  return true
end

function M.get_colors()
  local file = io.open(colors_file, "r")
  if not file then
    return {}
  end
  local content = file:read("*a")
  file:close()
  return parse_colors(content)
end

return M
