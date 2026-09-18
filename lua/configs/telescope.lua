-- Telescope configuration
-- Standalone (ex-NvChad). Treesitter is disabled in the previewer to avoid
-- ft_to_lang errors.

pcall(dofile, vim.g.base46_cache .. "telescope")

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

  extensions = {},
}

require("telescope").setup(options)
