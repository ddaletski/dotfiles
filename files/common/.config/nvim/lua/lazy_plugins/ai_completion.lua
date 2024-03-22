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
            vim.cmd([[
            inoremap <silent><script><expr> <C-l> codeium#Accept()
            inoremap <C-n> <cmd>call codeium#CycleCompletions(1)<cr>
            inoremap <C-p> <cmd>call codeium#CycleCompletions(-1)<cr>
            inoremap <silent><script><expr> <C-d> codeium#Clear()
            ]])
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
