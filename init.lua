-- REMAP
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--vim.keymap.set('n', '<CR>', 'j', {noremap = true})

-- SET
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.splitbelow = true  -- focus the window below when splitting
vim.opt.splitright = true  -- focus the window to the right when vsplitting

-- COLORS
-- Make background transparent, tbh, not a fan
function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalNone", { bg = "none" })
end
ColorMyPencils()

-- TELESCOPE
local builtin = require('telescope.builtin')

vim.keymap.set('n', 'C-p', builtin.git_files, {})

-- TREESITTER
require'nvim-treesitter.configs'.setup {
  ignore_install = { "help" },
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- UNDOTREE

--vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")  -- fuzzy find_files using telescope
--vim.keymap.set("n", "<leader>fg", ":Ag<space>")
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>")
vim.keymap.set("n", "<leader>fn", "<cmd>NERDTreeToggle<cr>")
vim.keymap.set("n", "<leader>gg", "<cmd>Git<cr>")
vim.keymap.set("n", "<leader>sv", "<cmd>:vsplit<cr>") -- split vert
vim.keymap.set("n", "<leader>sh", "<cmd>:split<cr>")  -- split horo

vim.keymap.set("n", "<leader>wl", "<C-w><Right>")  -- focus right
vim.keymap.set("n", "<leader>wh", "<C-w><Left>")  -- focus left
vim.keymap.set("n", "<leader>wj", "<C-w><Down>")  -- focus down
vim.keymap.set("n", "<leader>wk", "<C-w><Up>")  -- focus up

vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm size=50 dir=git_dir direction=vertical<cr>")
vim.keymap.set("n", "<leader>ta", ":ToggleTermToggleAll")

-- Configuration for diagnostics
local signs = {
  { name = 'DiagnosticSignError', text = '💩' },
  { name = 'DiagnosticSignWarn', text = '🛑' },
  { name = 'DiagnosticSignHint', text = '🚩' },
  { name = 'DiagnosticSignInfo', text = '💡' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

local config = {
  signs = {
    active = signs, -- show signs
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'single',
    source = 'always',
    header = 'Diagnostic',
    prefix = '',
  },
}

vim.diagnostic.config(config)

local on_attach = function(client, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function() vim.lsp.buf.format() end,
  })
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end


-- LSP SETUP
local nvim_lsp = require('lspconfig')
nvim_lsp["ruff_lsp"].setup {
    on_attach = on_attach,
    init_options = {
        settings = {
            organizeImports = true,
            lint = {
                -- enable = true,
                run = "onType", -- or "onType" | "onSave"
                args = {
                    "--select=E4,E7,E9,F,ARG,I",
                }
            }
        }
    }
}

-- CODE COMPLETION
-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['C-<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
nvim_lsp["ruff_lsp"].setup {
  capabilities = capabilities
  }

local servers = { "pyright", "tsserver", "ruff_lsp", "lua_ls", force = true }
for _, server in ipairs(servers) do
  nvim_lsp[server].setup { on_attach = on_attach }
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
