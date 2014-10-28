function desc = tensor_extract(I, cell_num)
% TENSOR_EXTRACT Extract the gradient tensor descriptor of an image.
%
%    DESC = TENSOR_EXTRACT(I) produce a single tensor descriptor, the input
%    is considered as an image patch. The function returns a 2 * 2 matrix
%    representing the tensor of patch gradient.
%
%    DESC = TENSOR_EXTRACT(I, CELL_NUM) produce a catenated descriptor of
%    tensor descriptors extracted from image cells. CELL_NUM could be a
%    single integer or a vector of length 2. The image is divided to
%    CELL_NUM * CELL_NUM cells when CELL_NUM is an integer. The function
%    returns a vector.

if nargin == 1
    % Extract single tensor descriptor.
    if size(I, 3) > 1
        I = rgb2gray(I);
    end
    I = im2double(I);
    [dx, dy] = gradient(I);
    dxdx = sum(sum(dx .* dx));
    dxdy = sum(sum(dx .* dy));
    dydy = sum(sum(dy .* dy));
    desc = [dxdx, dxdy; dxdy, dydy];
    desc = desc / norm(desc, 'fro');
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
    [height, width] = size(I);
    cell_height = floor(height / cell_row_num);
    cell_width = floor(width / cell_col_num);
    desc = zeros(cell_row_num * cell_col_num * 4, 1);
    index = 1;
    for r = 0 : cell_row_num - 1
        for c = 0 : cell_col_num - 1
            patch = I(r * cell_height + 1 : (r + 1) * cell_height, ...
                      c * cell_width + 1 : (c + 1) * cell_width);
            desc(index : index + 3) = reshape(tensor_extract(patch), 4, 1);
            index = index + 4;
        end
    end
end