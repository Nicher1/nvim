return {
  {
    'nvim-lua/plenary.nvim',
    lazy = false,
    config = function()
      vim.api.nvim_create_user_command('HackmudWrap', function()
        vim.cmd 'write' -- Save current file

        local input_file = vim.fn.expand '%:p'
        local output_file = vim.fn.expand '%:p:r' .. '.wrapped.js'

        -- Use Node to call the real terser.js file directly (bypass PowerShell policy)
        local terser_path = 'C:/Users/nl/AppData/Roaming/npm/node_modules/terser/bin/terser'
        local command = string.format([[node "%s" "%s" --compress --mangle --ecma 5]], terser_path, input_file)

        local result = vim.fn.system(command)

        if vim.v.shell_error ~= 0 or result == '' then
          vim.notify('Terser error:\n' .. result, vim.log.levels.ERROR)
          return
        end

        -- Remove "var s = " and trailing semicolon
        local stripped = result:gsub('^%s*var%s+s%s*=%s*', ''):gsub(';%s*$', '')
        local wrapped = 'function(c,a){' .. stripped .. '}'

        local f = io.open(output_file, 'w')
        if f then
          f:write(wrapped)
          f:close()
          vim.notify('✅ Hackmud script saved to: ' .. output_file)
        else
          vim.notify('❌ Failed to write output file.', vim.log.levels.ERROR)
        end
      end, { desc = 'Minify and wrap Hackmud script' })
    end,
  },
}
