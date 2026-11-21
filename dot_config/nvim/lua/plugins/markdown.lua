-- Markdown: marksman LSP (links, headings, TOC), in-buffer rendering, prettier formatting
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = { "marksman", "prettier" } },
  },

  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { markdown = { "prettier" } } },
  },

  -- render headings, code blocks, tables, checkboxes inline; raw text shows on the cursor line
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { completions = { blink = { enabled = true } } },
    keys = {
      { "<LocalLeader>m", "<Cmd>RenderMarkdown toggle<CR>", ft = "markdown", desc = "Toggle markdown render" },
    },
  },

  {
    "AstroNvim/astrocore",
    opts = {
      treesitter = { ensure_installed = { "markdown", "markdown_inline" } },
      autocmds = {
        markdown_prose = {
          {
            event = "FileType",
            pattern = "markdown",
            desc = "Soft-wrap and spellcheck markdown",
            callback = function()
              vim.opt_local.wrap = true
              vim.opt_local.linebreak = true
              vim.opt_local.spell = true
            end,
          },
        },
      },
    },
  },
}
