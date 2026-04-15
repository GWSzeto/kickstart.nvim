return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      local root_markers = {
        'eslint.config.js',
        'eslint.config.cjs',
        'eslint.config.mjs',
        'eslint.config.ts',
        'eslint.config.cts',
        'eslint.config.mts',
        '.eslintrc',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.json',
        '.prettierrc',
        '.prettierrc.json',
        '.prettierrc.yml',
        '.prettierrc.yaml',
        '.prettierrc.json5',
        '.prettierrc.js',
        '.prettierrc.cjs',
        '.prettierrc.mjs',
        'prettier.config.js',
        'prettier.config.cjs',
        'prettier.config.mjs',
        'package.json',
        '.git',
      }

      lint.linters_by_ft = {
        javascript = { 'oxlint', 'eslint' },
        javascriptreact = { 'oxlint', 'eslint' },
        -- markdown = { 'markdownlint' },
        solidity = { 'solhint' },
        typescript = { 'oxlint', 'eslint' },
        typescriptreact = { 'oxlint', 'eslint' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local function with_cwd(cwd, fn)
        local current = vim.fn.getcwd()
        if current == cwd then
          return fn()
        end

        vim.cmd.cd { cwd, mods = { noautocmd = true } }
        local ok, result = pcall(fn)
        vim.cmd.cd { current, mods = { noautocmd = true } }

        if ok then
          return result
        end
      end

      local function resolve_cmd(linter, cwd)
        if type(linter.cmd) == 'function' then
          return with_cwd(cwd, linter.cmd)
        end
        return linter.cmd
      end

      local function linter_available(linter, cwd)
        local cmd = resolve_cmd(linter, cwd)
        if type(cmd) ~= 'string' or cmd == '' then
          return false
        end
        if cmd:find '/' then
          return vim.uv.fs_stat(cmd) ~= nil
        end
        return vim.fn.executable(cmd) == 1
      end

      local function lint_cwd(bufnr)
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path == '' then
          return vim.fn.getcwd()
        end
        return vim.fs.root(path, root_markers) or vim.fs.dirname(path) or vim.fn.getcwd()
      end

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = lint_augroup,
        callback = function(args)
          local cwd = lint_cwd(args.buf)
          lint.try_lint(nil, {
            cwd = cwd,
            filter = function(linter)
              return linter_available(linter, cwd)
            end,
          })
        end,
      })
    end,
  },
}
