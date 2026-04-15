return {
  'sindrets/diffview.nvim',
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewRefresh',
    'DiffviewFileHistory',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('diffview').setup {}
  end,
}
