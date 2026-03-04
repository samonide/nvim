vim.pack.add({
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  {
    src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
})

local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local actions = require("telescope.actions")

-- Borrow the main-branch layout (top-aligned prompt, centered window)
telescope.setup({
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      n = { ["q"] = actions.close },
    },
    -- Disable treesitter highlighting in previewers to avoid ft_to_lang issues
    preview = {
      treesitter = false,
    },
  },
})

pcall(telescope.load_extension, "fzf")
