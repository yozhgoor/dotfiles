-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ","

vim.opt.lazyredraw = true
vim.opt.updatetime = 100

vim.opt.encoding = 'utf-8'
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.hidden = true

vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('filetype indent on')

vim.opt.spell = true
vim.opt.spelllang = 'en_us'

vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.shortmess:append("c")

vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes:1'
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.colorcolumn = '100'
vim.opt.textwidth = 100

vim.opt.clipboard = 'unnamedplus'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.breakindent = true

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "javascript", "yaml", "nix", "xml" },
  callback = function()
    vim.opt_local.colorcolumn = '80'
    vim.opt_local.textwidth = 80
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = "xml",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "markdown", "rust", "toml", "yaml" },
  callback = function()
    vim.cmd("highlight Invalid ctermbg=red guibg=red")
    vim.fn.matchadd("Invalid", [[\s*\t\s*\|\s*\t\s*\|\s\+$\|[^\x00-\xff]\+]])
  end
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = "*",
  command = [[%s/\s\+$//e]]
})

vim.keymap.set("", "<leader><Left>", ":bprev<CR>", { noremap = true, silent = true })
vim.keymap.set("", "<leader><Right>", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("", "<leader><Down>", ":bdel<CR>", { noremap = true, silent = true })
vim.keymap.set("", "Q", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("", "<PageUp>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("", "<PageDown>", "<Nop>", { noremap = true, silent = true })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- color scheme
    { "morhetz/gruvbox",
      lazy = false,
      config = function()
        vim.opt.background = "dark"
        vim.cmd("colorscheme gruvbox")
      end,
    },

    -- Icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- File explorer
    { "nvim-tree/nvim-tree.lua",
      lazy = false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.keymap.set("n", "<leader>m", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
        require("nvim-tree").setup({
          disable_netrw = true,
          diagnostics = {
            enable = true,
          },
          modified = { enable = true },
          actions = {
            open_file = {
              quit_on_open = true,
            },
          },
          filters = { git_ignored = true },
        })
      end,
    },

    -- Buffer line
    { "akinsho/bufferline.nvim",
      lazy = false,
      config = function()
        require("bufferline").setup({
          options = { separator_style = "thin" },
          highlights = {
            buffer_selected = {
              fg = "#00ff00",
              bold = false,
              italic = false,
            },
            buffer_visible = {
              fg = "#a89984",
              bold = false,
              italic = false,
            },
            separator = {
              fg = "#282828",
              bg = "#282828",
            },
            separator_selected = {
              fg = "#00ff00",
              bg = "#282828",
            },
          },
        })
      end,
    },

    -- Git signs
    { "lewis6991/gitsigns.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GitGutterAdd' })
        vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'GitGutterChange' })
        vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'GitGutterDelete' })
        require("gitsigns").setup({
          signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "-" },
          },
        })
      end,
    },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "bash",
            "comment",
            "diff",
            "regex",
            "gitignore",
            "html",
            "markdown",
            "python",
            "rust",
            "javascript",
            "ron",
            "toml",
            "yaml",
            "xml",
            "json",
            "nix",
            "mermaid",
            "sql",
          },
          sync_install = true,
          auto_install = true,
          highlight = { enable = true },
          additional_vim_regex_highlighting = false,
        })
      end,
    },
  },

  -- Disable hererocks and luarocks support
  rocks = {
    enabled = false,
    hererocks = false,
  },

  -- automatically check for plugin updates
  checker = { enabled = true },
})
