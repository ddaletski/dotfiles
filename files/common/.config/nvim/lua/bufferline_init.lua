vim.opt.termguicolors = true

require('bufferline').setup {
    options = {
        mode = "buffers",
        diagnostics = "coc",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local errors = diagnostics_dict["error"] or 0
            local warnings = (diagnostics_dict["warning"] or 0) + (diagnostics_dict["hint"] or 0)

            if errors > 0 then
                return "❌"
            elseif warnings > 0 then
                return "⚠️ "
            else
                return ""
            end
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
}
