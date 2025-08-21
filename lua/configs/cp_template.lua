-- Auto insert competitive programming C++ template on new empty *.cpp file
-- Keep minimal & fast; editing the file later will not re-insert.
local api = vim.api

api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.cpp",
  callback = function(args)
    local buf = args.buf
    if vim.api.nvim_buf_line_count(buf) > 1 then return end
    local lines = {
      '#include <bits/stdc++.h>',
      'using namespace std;',
      '',
      '#define fast_io ios::sync_with_stdio(false); cin.tie(nullptr);',
      '#define all(x) (x).begin(), (x).end()',
      '#define sz(x) (int)(x).size()',
      'using ll = long long;',
      '',
      'int main() {',
      '    fast_io;',
      '    int T = 1;',
      '    // cin >> T;',
      '    while (T--) {',
      '        ',
      '    }',
      '    return 0;',
      '}',
      '',
    }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, {13, 8}) -- place cursor inside loop body
  end,
})
