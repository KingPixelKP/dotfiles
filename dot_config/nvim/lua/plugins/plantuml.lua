-- PlantUML: filetype + syntax highlighting, and ,p to render the current diagram to SVG and open it
-- Rendering needs the `plantuml` binary (Arch/CachyOS: `sudo pacman -S plantuml`)
return {
  {
    "aklt/plantuml-syntax", -- detects *.puml/*.plantuml/*.pu/*.uml/*.iuml, syntax, makeprg
    ft = "plantuml",
    init = function()
      vim.filetype.add { extension = { puml = "plantuml", plantuml = "plantuml", pu = "plantuml", iuml = "plantuml" } }
    end,
  },

  {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
        plantuml = {
          {
            event = "FileType",
            pattern = "plantuml",
            desc = "PlantUML comments and render key",
            callback = function(args)
              vim.bo[args.buf].commentstring = "' %s"
              vim.keymap.set("n", "<LocalLeader>p", function()
                if vim.fn.executable "plantuml" == 0 then
                  return vim.notify("plantuml not installed (sudo pacman -S plantuml)", vim.log.levels.ERROR)
                end
                vim.cmd.write()
                local file = vim.api.nvim_buf_get_name(args.buf)
                local out = vim.fn.fnamemodify(file, ":r") .. ".svg"
                -- -pipe: output always goes to <file>.svg, regardless of the `@startuml <name>` title
                vim.system({ "plantuml", "-pipe", "-tsvg" }, {
                  stdin = table.concat(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false), "\n"),
                  cwd = vim.fn.fnamemodify(file, ":h"), -- resolve relative !include
                }, function(res)
                  vim.schedule(function()
                    if res.code ~= 0 then
                      local msg = (res.stderr ~= "" and res.stderr) or "render failed (syntax error?)"
                      return vim.notify(msg, vim.log.levels.ERROR, { title = "plantuml" })
                    end
                    local f = assert(io.open(out, "wb"))
                    f:write(res.stdout)
                    f:close()
                    local _, err = vim.ui.open(out)
                    if err then vim.notify(err, vim.log.levels.ERROR, { title = "plantuml" }) end
                  end)
                end)
              end, { buffer = args.buf, desc = "Render PlantUML to SVG" })
            end,
          },
        },
      },
    },
  },
}
