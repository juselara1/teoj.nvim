local M = {}

M.select_lines = function (start_pos, end_pos)
    vim.api.nvim_win_set_cursor(0, start_pos)
    if vim.fn.mode() ~= 'v' then
        vim.cmd("normal! v")
    end
    vim.api.nvim_win_set_cursor(0, end_pos)
end

return M
