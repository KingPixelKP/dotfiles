return {
  -- LSP
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = {
        "pyright",
      },
      -- ruff LSP: lint diagnostics + quick fixes; leave hover to pyright
      config = {
        ruff = {
          on_attach = function(client) client.server_capabilities.hoverProvider = false end,
        },
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = { "ruff" } },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
  },

  -- Debugger
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")

      dap.adapters.python = {
        type = "executable",
        command = "debugpy-adapter",
        args = {},
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          -- use the venv picked with :VenvSelect, else whatever `python` is on PATH
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            return venv and (venv .. "/bin/python") or "python"
          end,
        },
      }
    end,
  },

  -- Interpreter picker (like VS Code's "Python: Select Interpreter")
  -- finds uv/.venv envs, updates pyright, remembers choice per project
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    cmd = "VenvSelect",
    keys = { { "<LocalLeader>v", "<Cmd>VenvSelect<CR>", desc = "Select Python interpreter" } },
    opts = {
      options = { picker = "snacks" },
      search = {
        -- uv-managed envs (PEP-723 scripts, `uv run --with ...`) live in uv's cache
        uv_cache = {
          command = "$FD '/bin/python$' ~/.cache/uv/environments-v2 --full-path --color never -a -d 3",
        },
      },
    },
    config = function(_, opts)
      require("venv-selector").setup(opts)

      -- PEP-723 scripts (`# /// script` header): venv-selector syncs the uv env on save but
      -- does not restart pyright (same python path), so new deps/stubs stay unresolved.
      -- When the header changes (save or external `uv add --script`), sync and restart pyright.
      local function script_header(buf)
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local s
        for i, l in ipairs(lines) do
          if not s and l:match "^# /// script%s*$" then
            s = i
          elseif s and l:match "^# ///%s*$" then
            return table.concat(lines, "\n", s, i)
          end
        end
      end

      local group = vim.api.nvim_create_augroup("pep723_lsp_restart", { clear = true })
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = group,
        pattern = "*.py",
        callback = function(ev) vim.b[ev.buf].pep723_header = script_header(ev.buf) end,
      })
      vim.api.nvim_create_autocmd({ "BufWritePost", "FileChangedShellPost" }, {
        group = group,
        pattern = "*.py",
        callback = function(ev)
          local buf, header = ev.buf, script_header(ev.buf)
          if not header or header == vim.b[buf].pep723_header then return end
          vim.b[buf].pep723_header = header
          local file = vim.api.nvim_buf_get_name(buf)
          vim.system({ "uv", "sync", "--script", file }, { text = true }, function(res)
            vim.schedule(function()
              if res.code ~= 0 then
                vim.notify(res.stderr, vim.log.levels.ERROR, { title = "uv sync" })
              elseif vim.api.nvim_buf_is_valid(buf) and #vim.lsp.get_clients { bufnr = buf, name = "pyright" } > 0 then
                vim.cmd "lsp restart pyright"
              end
            end)
          end)
        end,
      })
    end,
  },

  {
  "AstroNvim/astrocore",
  opts = function()
    vim.cmd([[
      anoremenu PopUp.Hover\ Documentation <Cmd>lua vim.lsp.buf.hover()<CR>
    ]])
  end,
  },
}
