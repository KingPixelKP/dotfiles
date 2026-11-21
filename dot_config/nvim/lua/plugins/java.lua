-- Java: jdtls via nvim-jdtls (debugging, tests, organize imports, extract refactors)
-- Mason packages used: jdtls, java-debug-adapter, java-test
local mason = vim.fn.stdpath "data" .. "/mason"

return {
  -- stop AstroLSP from starting a plain lspconfig jdtls; nvim-jdtls owns it
  {
    "AstroNvim/astrolsp",
    opts = { handlers = { jdtls = false } },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = { "jdtls", "java-debug-adapter", "java-test" } },
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local function bundles()
        local b = vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
        for _, jar in ipairs(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", true, true)) do
          local name = vim.fn.fnamemodify(jar, ":t")
          -- these two break jdtls if loaded as bundles
          if name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" and name ~= "jacocoagent.jar" then
            table.insert(b, jar)
          end
        end
        return b
      end

      local function start()
        local root = vim.fs.root(0, { "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
          or vim.fn.getcwd()
        -- one jdtls workspace (index cache) per project
        local workspace = vim.fn.stdpath "cache" .. "/jdtls/" .. vim.fn.fnamemodify(root, ":p:h"):gsub("/", "%%")

        require("jdtls").start_or_attach {
          name = "jdtls",
          cmd = { mason .. "/bin/jdtls", "-data", workspace },
          root_dir = root,
          capabilities = require("astrolsp").config.capabilities,
          init_options = { bundles = bundles() },
          settings = {
            java = {
              signatureHelp = { enabled = true },
              contentProvider = { preferred = "fernflower" }, -- decompile .class on goto-definition
              sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
            },
          },
          on_attach = function(client, bufnr)
            require("astrolsp").on_attach(client, bufnr) -- keep AstroNvim LSP mappings/format-on-save
            local jdtls = require "jdtls"
            jdtls.setup_dap { hotcodereplace = "auto" }
            require("jdtls.dap").setup_dap_main_class_configs() -- `:DapContinue` lists main classes

            local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc }) end
            map("<LocalLeader>o", jdtls.organize_imports, "Organize imports")
            map("<LocalLeader>tc", jdtls.test_class, "Test class")
            map("<LocalLeader>tm", jdtls.test_nearest_method, "Test nearest method")
            map("<LocalLeader>ev", jdtls.extract_variable, "Extract variable")
            map("<LocalLeader>ec", jdtls.extract_constant, "Extract constant")
            vim.keymap.set("v", "<LocalLeader>em", function() jdtls.extract_method(true) end, { buffer = bufnr, desc = "Extract method" })
          end,
        }
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("jdtls_start", { clear = true }),
        pattern = "java",
        callback = start,
      })
      start() -- plugin loads on the first java FileType, which already fired
    end,
  },
}
