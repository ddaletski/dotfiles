vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local nvimTreeProps = {}
local api = require("nvim-tree.api")

function nvimTreeProps.on_attach(bufnr)
    --vim.keymap.set('n', '?', api.tree.toggle_help,
    --{ desc = 'Help', buffer = bufnr, noremap = true, silent = true, nowait = true })
end

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
    pattern = "NvimTree_*",
    callback = function()
        local layout = vim.api.nvim_call_function("winlayout", {})
        if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
            vim.cmd("confirm quit")
        end
    end
})
