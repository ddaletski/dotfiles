return {
    {
        "Exafunction/codeium.vim",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = "Codeium",
        event = "InsertEnter",
        init = function()
            vim.g.codeium_disable_bindings = 1
        end,
        cond = function()
            return vim.env.NVIM_AI_COMPLETION == "codeium"
        end,
        config = function()
            vim.keymap.set("i", "<C-l>", "<Cmd>call codeium#Accept()<CR>", { silent = true, nowait = true, expr = true })
            vim.keymap.set("i", "<C-n>", "<Cmd>call codeium#CycleCompletions(1)<CR>")
            vim.keymap.set("i", "<C-p>", "<Cmd>call codeium#CycleCompletions(-1)<CR>")
            vim.keymap.set("i", "<C-d>", "<Cmd>call codeium#Clear()<CR>")
        end
    },
    {
        "github/copilot.vim",
        lazy = true,
        cmd = "Copilot",
        event = "InsertEnter",
        cond = function()
            return vim.env.NVIM_AI_COMPLETION == "copilot"
        end
    },
}
