return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  init = function()
    vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = '[E]xplorer (Neo-tree)' })
  end,
}
