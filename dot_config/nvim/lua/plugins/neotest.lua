
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "orjangj/neotest-ctest",
    "nvim-neotest/neotest-python",
    "rcasia/neotest-java",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-ctest").setup({
          -- Optional: match your nvim-dap adapter name ("codelldb" or "cppdbg")
          dap_adapter = "codelldb",
        }),
        require("neotest-python")({
          runner = "pytest",
          -- run tests with the interpreter picked in :VenvSelect (or the uv script env)
          python = function()
            local ok, vs = pcall(require, "venv-selector")
            return (ok and vs.python()) or "python"
          end,
        }),
        -- JUnit via jdtls classpath; run `:NeotestJava setup` once to download the JUnit jar
        require("neotest-java")({}),
      },
    })
  end,
  keys = {
    -- <Leader>T prefix: <Leader>t is AstroNvim's terminal group (<Leader>tf = float terminal)
    { "<leader>T", desc = "Tests" },
    { "<leader>Tt", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
    { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run Test File" },
    { "<leader>Ta", function() require("neotest").run.run({ suite = true }) end, desc = "Run All Tests" },
    { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
    { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary" },
    { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "Show Test Output" },
  },
}
