-- Exit if the language server isn't available
if vim.fn.executable('nil') ~= 1 then
  return
end

local root_files = {
  'flake.nix',
  'default.nix',
  'shell.nix',
  '.git',
}

vim.lsp.start {
  name = 'nil_ls',
  cmd = { 'nil' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
  on_attach = function(client, bufnr)
    -- Enable formatting on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        local params = {
          textDocument = {
            uri = vim.uri_from_bufnr(bufnr)
          }
        }
        client.request('textDocument/formatting', params, nil, bufnr)
      end,
    })
  end,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" }
      }
    }
  }
}
