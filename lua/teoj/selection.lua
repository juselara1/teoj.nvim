local M = {}

-- This functions selects the text between a range in the current active buffer.
-- @param start_pos table representing {row, column} of the first character to select.
-- @param end_pos table representing {row, column} of the last character to select.
-- @return the sum of a and b
M.select_range = function (start_pos, end_pos)
    vim.api.nvim_win_set_cursor(0, start_pos)
    if vim.fn.mode() == 'v' then
        vim.cmd("normal! v")
    end
    vim.cmd("normal! v")
    vim.api.nvim_win_set_cursor(0, end_pos)
end

return M
