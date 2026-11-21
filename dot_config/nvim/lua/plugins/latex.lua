-- LaTeX: vimtex (compile with latexmk, PDF view, motions/text objects, TOC)
-- Main maps (localleader ","): ,ll compile (continuous), ,lv view PDF, ,lt TOC, ,le errors, ,lc clean
return {
  {
    "lervag/vimtex",
    lazy = false, -- vimtex must not be lazy-loaded (breaks inverse search and ft detection)
    init = function()
      vim.g.vimtex_view_method = "general" -- xdg-open; set "zathura" if you install it (enables forward/inverse search)
      vim.g.vimtex_quickfix_open_on_warning = 0
    end,
  },

  -- vimtex provides its own syntax highlighting; treesitter latex highlighting disables it
  {
    "AstroNvim/astrocore",
    opts = {
      treesitter = {
        highlight = function(lang) return lang ~= "latex" end,
      },
    },
  },
}
