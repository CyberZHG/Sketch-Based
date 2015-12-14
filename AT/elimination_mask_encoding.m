function code = elimination_mask_encoding(mask)
% ELIMINATION_MASK_ENCODING Transfer a 3 * 3 mask to a single number.
%
%   CODE = ELIMINATION_MASK_ENCODING(MASK) Trasfer the input 3 * 3 logical
%   mask to a single number for elimination of thinning.

weight = [1 2 4; 8 16 32; 64 128 256];
code = sum(sum(mask .* weight));