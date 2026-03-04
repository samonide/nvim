vim.pack.add({
  { src = "https://github.com/samonide/timesense.nvim" },
})

local ok, timesense = pcall(require, "timesense")
if not ok then
  return
end

timesense.setup()
