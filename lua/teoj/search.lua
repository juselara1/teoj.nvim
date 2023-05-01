local M = {}

-- This function extracts the text in a given line.
-- @param line_number the row number.
-- @return the extracted text
function get_line(line_number)
    line = vim.api.nvim_buf_get_lines(bufnr, line_number - 1, line_number, false)[1]
    return line
end

-- This function extracts the span of all the matches in a given text.
-- @param text text to extract the pattern.
-- @return a table with all the matches, where each match is a table with the keys `start_pos` and `end_pos`.
function get_matches(text, pattern)
    matches = {}
    start_pos = 1
    searching = true
    while start_pos < #text and searching do
        s, e = string.find(text, pattern, start_pos)
        if s == nil then
            searching = false
        else
            table.insert(matches, {start_pos=s, end_pos=e})
            start_pos = e + 1
        end
    end
    return matches
end

-- This function finds the closest pattern given an orientation.
-- @param initial_pos this represents a initial position in the buffer.
-- @param pattern lua pattern to find.
-- @param left_prority determines if the search must be performed backwards (true) or forward (true)
-- @return a table with the best match, it has the following structure: {row=2, columns={start_pos=1, end_pos=3}}.
function find_match(initial_pos, pattern, left_priority)
    line_id = initial_pos.row
    line = get_line(line_id)
    matches = get_matches(line, pattern)
    total_lines = vim.api.nvim_buf_line_count(bufnr)
    if #matches == 1 then
        return {row=initial_pos.row, columns=matches[1]}
    elseif #matches == 0 and (initial_pos.row == 1 or initial_pos.row == total_lines) then
        return nil
    elseif #matches == 0 and left_priority then
        position = {row = initial_pos.row - 1, column = #(get_line(initial_pos.row - 1))}
        return find_match(position, pattern, left_priority)
    elseif #matches == 0 and not left_priority then
        position = {row = initial_pos.row + 1, column = 1}
        return find_match(position, pattern, left_priority)
    elseif #matches > 1 and left_priority then
        best_diff = nil
        for _, match in ipairs(matches) do
            diff =  initial_pos.column - match.start_pos + 1
            if diff >= 0 and (best_diff == nil or diff < best_diff) then
                best_diff = diff
                best_match = match
            end
        end
        return {row = initial_pos.row, columns=best_match}
    else
        best_diff = nil
        for _, match in ipairs(matches) do
            diff = match.start_pos - initial_pos.column - 1
            if diff >= 0 and (best_diff == nil or diff < best_diff) then
                best_diff = diff
                best_match = match
            end
        end
        return {row = initial_pos.row, columns=best_match}
    end
end

-- This function extracts the range between two patterns.
-- @param pattern_l pattern for backward search.
-- @param pattern_r pattern for forward search.
-- @return a table with the range of the matches, it has the `left` and `right` keys which correspond
-- to the left and right matches.
M.get_range = function (pattern_l, pattern_r)
    bufnr = vim.api.nvim_get_current_buf()
    initial_pos = vim.api.nvim_win_get_cursor(0)
    initial_pos = {row = initial_pos[1], column = initial_pos[2]}
    left_match = find_match(initial_pos, pattern_l, true)
    right_match = find_match(initial_pos, pattern_r, false)
    return {left=left_match, right=right_match}
end

-- This function fixes a buffer position in case of overflow.
-- @param position a table representing a position in the buffer in the form of {row, column}
-- @return the fixed position.
M.fix_position = function (position)
    if position[2] < 0 then
        position = {position[1] - 1, #get_line(position[1] - 1)}
    elseif position[2] > #get_line(position[1]) - 1 then
        position = {position[1] + 1, 0}
    end
    return position
end

return M
