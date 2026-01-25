-- Telescope configuration
-- Extends NvChad's default config and disables treesitter in previewer to avoid API compatibility issues

dofile(vim.g.base46_cache .. "telescope")

local options = {
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
      n = { ["q"] = require("telescope.actions").close },
    },
    -- Disable treesitter highlighting in previewer to avoid ft_to_lang errors
    preview = {
      treesitter = false,
    },
  },

  extensions_list = { "themes", "terms" },
  extensions = {},
}

require("telescope").setup(options)
