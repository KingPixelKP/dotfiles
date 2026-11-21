-- Show dotfiles and gitignored files in neo-tree (press H in the tree to toggle filtered items)
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { ".git" },
      },
    },
  },
}
