---------------- download lazy.nvim ---------------------------
---------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
---------------------------------------------------------------

local plugins = {
    {
        -- automatically import all specs from `lazy_plugins` directory
        import = "lazy_plugins"
    },
    "mg979/vim-visual-multi",
    "kamykn/popup-menu.nvim",
    "kyazdani42/nvim-web-devicons",
    "alvan/vim-closetag",
    "shougo/echodoc",
    "preservim/nerdcommenter",
    "vim-airline/vim-airline",
    "voldikss/vim-floaterm",
    "puremourning/vimspector",
    "tikhomirov/vim-glsl",
    "junegunn/goyo.vim", -- focus mode
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && yarn install",
    },
    "gauteh/vim-cppman",
    {
        "rhysd/rust-doc.vim",
        ft = "rust",
        cmd = "RustDoc",
        init = function()
            vim.g["rust_doc#define_map_K"] = 0
        end
    },
    "slint-ui/vim-slint",
    {
        "phaazon/hop.nvim",
        opts = {
            keys = 'etovxqpdygfblzhckisuran',
        }
    },
    {
        "saecki/crates.nvim",
        opts = {
            completion = {
                coq = {
                    enabled = true,
                    name = "crates.nvim",
                },
            },
        }
    },
    {
        "folke/neodev.nvim",
        opts = {
            lspconfig = false,
        }
    },
    {
        "neoclide/coc.nvim",
        branch = "release",
        init = function()
            vim.g.coc_global_extensions = {
                "coc-highlight",
                "coc-pyright",
                "coc-rust-analyzer",
                "coc-vimlsp",
                "coc-sumneko-lua",
                "coc-cmake",
                "coc-json",
                "coc-sh",
                "coc-markdownlint",
                "coc-toml",
                "coc-html",
                "coc-tsserver",
                "coc-tslint-plugin",
                "coc-svelte",
            }
        end
    },
}

require("lazy").setup(plugins)


-- open live grep with last query
local telescope = require('telescope.builtin')
local state = require("telescope.state")

function TelescopeStatefulLiveGrep()
    local cached_pickers = state.get_global_key "cached_pickers"
    if (cached_pickers ~= nil and cached_pickers[1].prompt_title == "Live Grep") then
        telescope.resume()
    else
        telescope.live_grep()
    end
end
