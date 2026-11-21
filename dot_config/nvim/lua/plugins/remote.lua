
return {
  "amitds1997/remote-nvim.nvim",
  version = "*", -- Pin to GitHub releases
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    -- Automatically launch Neovide instead of a terminal window when connecting
    client_callback = function(port, workspace_config)
      local cmd = ("neovide --server=localhost:%s"):format(port)
      if vim.fn.has("win32") == 1 then
        cmd = ("start %s"):format(cmd)
      end
      vim.fn.jobstart(cmd, {
        detach = true,
        on_exit = function(job_id, exit_code, event_type)
          print("Neovide client exited with code", exit_code)
        end,
      })
    end,
  },
}
