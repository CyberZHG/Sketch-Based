function vis = tensor_visualization(I, cell_num)
% TENSOR_VISUALIZATION Visualize the gradient tensor descriptor.

vis = I;
if nargin == 1
    height = size(I, 1);
    width = size(I, 2);
    desc = tensor_extract(I);
    vis = draw_line(vis, height, 1, height, width);
    vis = draw_line(vis, 1, width, height, width);
    [V, D] = eig(desc);
    cy = round(height / 2);
    cx = round(width / 2);
    max_length = min(height, width) * 0.475;
    theta = atan2(V(1, 2), V(1, 1)) + pi / 2;
    ty = round(max_length * D(1, 1) * sin(theta));
    tx = round(max_length * D(1, 1) * cos(theta));
    vis = draw_line(vis, cy, cx, cy + ty, cx + tx);
    vis = draw_line(vis, cy, cx, cy - ty, cx - tx);
    theta = atan2(V(2, 2), V(2, 1)) + pi / 2;
    ty = round(max_length * D(2, 2) * sin(theta));
    tx = round(max_length * D(2, 2) * cos(theta));
    vis = draw_line(vis, cy, cx, cy + ty, cx + tx);
    vis = draw_line(vis, cy, cx, cy - ty, cx - tx);
else
    if length(cell_num) == 1
        cell_row_num = cell_num;
        cell_col_num = cell_num;
    elseif length(cell_num) == 2
        cell_row_num = cell_num(1);
        cell_col_num = cell_num(2);
    else
        error('The format of CELL_NUM is not correct.');
    end
    height = size(I, 1);
    width = size(I, 2);
    cell_height = floor(height / cell_row_num);
    cell_width = floor(width / cell_col_num);
    for r = 0 : cell_row_num - 1
        for c = 0 : cell_col_num - 1
            index_r = r * cell_height + 1 : (r + 1) * cell_height;
            index_c = c * cell_width + 1 : (c + 1) * cell_width;
            patch = I(index_r, index_c, :);
            vis(index_r, index_c, :) = tensor_visualization(patch);
        end
    end
end