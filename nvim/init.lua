-- ~/.config/nvim/init.lua

-- ========================================================================== --
-- 1. BOOTSTRAP LAZY (Package Manager)
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
-- 2. PLUGINS
-- ========================================================================== --
require("lazy").setup({
    -- THEME
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    -- TREESITTER (The Engine)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "master", -- REQUIRED: Fixes the breaking change
        config = function ()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "markdown", "markdown_inline", "lua", "vim", "vimdoc",
                    "go", "gomod", "gosum",
                    "python",
                    "hcl", "terraform",
                    "yaml", "json", "toml",
                    "bash",
                    "dockerfile",
                    "html", "css", "javascript", "typescript",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end
    },

    -- RENDER MARKDOWN (The Visuals)
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('render-markdown').setup({})
        end,
    },
}, {
    rocks = { enabled = false }, -- Fixes Luarocks warning
})

-- ========================================================================== --
-- 3. GENERAL SETTINGS
-- ========================================================================== --
-- Enable line wrapping so text doesn't run off the screen
vim.opt.wrap = true

-- Break lines at words rather than in the middle of a word
vim.opt.linebreak = true

-- Hides raw markdown characters (like **bold** or [link](url)) when not editing them
-- Level 2 is usually the sweet spot for note-taking
vim.opt.conceallevel = 2

-- HYBRID LINE NUMBERS
vim.opt.number = true         -- Shows "42" on the line you are on
vim.opt.relativenumber = true -- Shows "1, 2, 3..." for lines above/below

-- System clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Smart search (case-insensitive unless uppercase is used)
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ========================================================================== --
-- 4. KEYMAPS
-- ========================================================================== --
-- Remap j and k to move by "visual" line rather than "physical" line.
-- This is crucial when 'wrap' is on, so you can move cursor naturally inside a long paragraph.
vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })

-- Quick vertical movement
vim.keymap.set('n', '<C-d>', '<C-d>zz')  -- center after jump
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Keep search results centered
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
