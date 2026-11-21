-- GitHub Copilot via the official copilot-language-server + Neovim's native inline completion
-- Sign in once with :LspCopilotSignIn (opens a device-code flow in the browser)
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = { "copilot-language-server" } },
  },

  -- AstroLSP auto-enables the server once Mason installs it
  {
    "AstroNvim/astrolsp",
    opts = {
      features = { inline_completion = true }, -- ghost-text suggestions (off by default in AstroLSP)
      config = {
        copilot = { settings = { telemetry = { telemetryLevel = "off" } } },
      },
      mappings = {
        i = {
          ["<M-l>"] = {
            function() vim.lsp.inline_completion.get() end,
            desc = "Accept inline suggestion",
            cond = "textDocument/inlineCompletion",
          },
          ["<M-]>"] = {
            function() vim.lsp.inline_completion.select { count = 1 } end,
            desc = "Next inline suggestion",
            cond = "textDocument/inlineCompletion",
          },
          ["<M-[>"] = {
            function() vim.lsp.inline_completion.select { count = -1 } end,
            desc = "Previous inline suggestion",
            cond = "textDocument/inlineCompletion",
          },
        },
      },
    },
  },
}
