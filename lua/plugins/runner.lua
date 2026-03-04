vim.pack.add({
  { src = "https://github.com/samonide/runner.nvim" },
})

local ok, runner = pcall(require, "runner")
if not ok then
  return
end

runner.setup({
  build_dir = ".build",
  test_dir = "tests",
  input_file = "input.txt",
  output_file = "output.txt",
  show_time = true,
  clean_after_run = false,
  terminal = {
    split_height = 15,
    position = "botright",
  },
})
