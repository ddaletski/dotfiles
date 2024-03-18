return {
    "akinsho/bufferline.nvim",
    tag = "v4.*",
    opts = {
        options = {
            mode = "buffers",
            diagnostics = "coc",
            diagnostics_indicator = function(_, _, diagnostics_dict, _)
                local errors = diagnostics_dict["error"] or 0
                local warnings = (diagnostics_dict["warning"] or 0) + (diagnostics_dict["hint"] or 0)

                if errors + warnings == 0 then
                    return ""
                end

                local indicator = " "

                if errors > 0 then
                    indicator = indicator .. "❌" .. errors
                end

                if warnings > 0 then
                    indicator = indicator .. "⚠️" .. warnings
                end

                return indicator
            end,

            custom_filter = function(buf_number, _)
                if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                    return true
                end
                return false
            end,
            color_icons = true,
            persist_buffer_sort = true,
            always_show_bufferline = true,
        }
    },
    init = function()
        vim.opt.termguicolors = true
    end
}
