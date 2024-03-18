return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
        local def_config = {
            layout_strategy = "vertical",
            sorting_strategy = "ascending",
            scroll_strategy = "limit",
            layout_config = {
                vertical = {
                    mirror = true,
                    preview_cutoff = 1,
                    prompt_position = "top",
                    height = function(_, _, max_lines)
                        return math.min(math.floor(max_lines * 0.95), 40)
                    end,
                    width = function(_, max_cols, _)
                        return math.min(math.floor(max_cols * 0.9), 120)
                    end,
                    preview_height = function(_, _, max_lines)
                        return math.min(math.floor(max_lines * 0.5), 12)
                    end,
                },
            },
            mappings = {
                ["i"] = {
                    ["<C-h>"] = "which_key",
                    ["<C-j>"] = "move_selection_next",
                    ["<C-k>"] = "move_selection_previous"
                },
                ["n"] = {
                },
            }
        }

        local opts = {
            defaults = def_config,
            pickers = {
                buffers = {
                    initial_mode = "normal",
                    preview_cutoff = 1,
                    layout_config = {
                        vertical = {
                            preview_height = 12,
                            width = function(_, max_cols, _)
                                return math.min(math.floor(max_cols * 0.9), 120)
                            end,
                        },
                    },

                    mappings = {
                        ["i"] = {
                            --['<c-d>'] = require('telescope.actions').delete_buffer
                        },
                        ["n"] = {
                            ['d'] = require('telescope.actions').delete_buffer
                        }
                    }
                },
                colorscheme = {
                    enable_preview = true
                },
                live_grep = {
                },
                git_status = {
                    theme = "ivy",
                    initial_mode = "normal",
                },
                git_commits = {
                    theme = "ivy",
                    initial_mode = "normal",
                },
                git_branches = {
                    theme = "ivy",
                    initial_mode = "normal",
                },
                current_buffer_fuzzy_find = {
                },
                find_files = {
                    hidden = false,
                    layout_config = {
                        vertical = {
                            width = function(_, max_cols, _)
                                return math.min(math.floor(max_cols * 0.9), 80)
                            end,
                        },
                    }
                },
            },
            extensions = {
                file_browser = {
                    theme = "ivy",
                    initial_mode = "normal",
                    layout_config = {
                        preview_width = function(_, w, _)
                            return math.floor(w * 0.6)
                        end,
                        height = function(_, _, h)
                            return math.floor(h * 1.0)
                        end
                    },
                    -- disables netrw and use telescope-file-browser in its place
                    hijack_netrw = true,
                    mappings = {
                        ["i"] = {
                        },
                        ["n"] = {
                        },
                    },
                },
            },
        }

        require("telescope").setup(opts)
        require("telescope").load_extension "file_browser"

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
    end
}
