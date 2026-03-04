vim.pack.add({
  { src = "https://github.com/folke/todo-comments.nvim" },
})

local ok, todo = pcall(require, "todo-comments")
if not ok then
  return
end

todo.setup({
  signs = true,
})
