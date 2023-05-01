local search = require("teoj.search")
local selection = require("teoj.selection")

M = {}

-- This function allows to define a new text object given two patterns and its flags.
-- @param pattern_l pattern for backward search.
-- @param pattern_r pattern for forward search.
-- @param left_inclusive specifies if the left pattern must be selected.
-- @param right_inclusive specifies if the right pattern must be selected.
M.object = function(pattern_l, pattern_r, left_inclusive, right_inclusive)
    range = search.get_range(pattern_l, pattern_r)
    if range.left == nil or range.right == nil then
        return
    end
    if left_inclusive then
        left_range = {range.left.row, range.left.columns.start_pos - 1}
    else
        left_range = search.fix_position({range.left.row, range.left.columns.end_pos})
    end

    if right_inclusive then
        right_range = {range.right.row, range.right.columns.end_pos - 1}
    else
        right_range = search.fix_position({range.right.row, range.right.columns.start_pos - 2})
    end
    selection.select_range(left_range, right_range)
end

return M
