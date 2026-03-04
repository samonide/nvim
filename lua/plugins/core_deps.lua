vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

local ok, devicons = pcall(require, "nvim-web-devicons")
if ok then
  devicons.setup()
end
