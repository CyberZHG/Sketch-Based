function code = elimination_mask_encoding(mask)
% ELIMINATION_MASK_ENCODING Transfer a 3 * 3 mask to a single number.
%
%   CODE = ELIMINATION_MASK_ENCODING(MASK) Trasfer the input 3 * 3 logical
%   mask to a single number for elimination of thinning.

code = 0;
for i = 1 : 3
    for j = 1 : 3
        code = bitshift(code, 1) + mask(i, j);
    end
end