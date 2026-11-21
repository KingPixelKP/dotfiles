return {
  -- conform owns format-on-save (falls back to LSP formatting when no conform formatter is set);
  -- AstroLSP's LSP-only autocmd is disabled so files are not formatted twice
  {
    "AstroNvim/astrolsp",
    opts = { autocmds = { lsp_auto_format = false } },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      format_on_save = function(bufnr)
        -- respect AstroNvim's <Leader>uf / <Leader>uF autoformat toggles
        if not require("astrolsp").autoformat_enabled(bufnr) then return end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        python = { "black" },
        lua = { "stylua" },
        -- config files
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        toml = { "taplo" },
        xml = { "xmllint" }, -- from libxml2 (system package)
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = { "prettier", "taplo", "stylua" } },
  },
}
