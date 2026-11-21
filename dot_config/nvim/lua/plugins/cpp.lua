
return {
  -- 1. Mason & LSP Bridge (connects clangd and neocmakelsp)
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "clangd", "neocmakelsp" },
    },
  },

  -- 2. CMake Build, Run & Debug Integration
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate" },
      { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
      { "<leader>cr", "<cmd>CMakeRun<cr>", desc = "CMake Run" },
      { "<leader>cd", "<cmd>CMakeDebug<cr>", desc = "CMake Debug" },
      { "<leader>ct", "<cmd>CMakeRunTest<cr>", desc = "CMake Run Test" },
    },
  },

  -- 3. Debugger Bridge (connects Mason's codelldb to nvim-dap)
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = { "codelldb" },
      handlers = {}, -- Automatically sets up codelldb with default config
    },
  },
}
