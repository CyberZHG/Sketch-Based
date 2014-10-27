function Ith = thinning(I)
% THINNING Produce thinned version of the input sketch image.
%
%   ITH = THINNING(I) produce a one-pixel-wide skeleton. The input sketch 
%   should be a binarized image with only one channel, and the skeleton 
%   should be represented by 0.

ELIMINATION_MASK = cell(8, 1);
ELIMINATION_MASK{3} = [303; 423; 207; 111; 489; 459; 486; 492];
ELIMINATION_MASK{4} = [47; 295; 203; 79; 488; 457; 422; 484; 331; 271; 460; 205];
ELIMINATION_MASK{5} = [39; 294; 75; 15; 456; 201; 420; 480; 267; 204];
ELIMINATION_MASK{6} = [38; 292; 11; 7; 200; 73; 416; 448];
ELIMINATION_MASK{7} = [36; 288; 3; 6; 72; 9; 384; 192];
ELIMINATION_MASK{8} = [32; 2; 8; 128];

PRESEVERED_MASK = cell(7, 1);
PRESEVERED_MASK{1} = [2, 1, 2; 
                      0, 0, 0; 
                      0, 0, 0; 
                      2, 1, 2];
PRESEVERED_MASK{2} = [2, 1, 1; 
                      0, 0, 1; 
                      1, 0, 1; 
                      1, 1, 2];
PRESEVERED_MASK{3} = [2, 1, 1; 
                      0, 0, 1; 
                      1, 0, 1; 
                      1, 1, 2];
PRESEVERED_MASK{4} = [2, 1, 1, 1;
                      1, 0, 0, 1;
                      1, 1, 0, 2];
PRESEVERED_MASK{5} = [2, 0, 0, 2;
                      1, 0, 0, 1;
                      2, 0, 0, 2];
PRESEVERED_MASK{6} = [1, 1, 1, 2;
                      1, 0, 0, 1;
                      2, 0, 1, 1];
PRESEVERED_MASK{7} = [1, 1, 1, 1;
                      1, 0, 0, 1;
                      1, 0, 0, 1;
                      1, 1, 1, 1];
PRESEVERED_MASK_CENTROID = [2, 2; 3, 2; 2, 2; 2, 2; 2, 2; 2, 3; 2, 2];

% Remove pixels on border.
[height, width] = size(I);
I(1, :) = 1;
I(height, :) = 1;
I(:, 1) = 1;
I(:, width) = 1;
while 1 == 1
    eliminated = 0;
    Ith = ones(height, width);
    parfor y = 2 : height - 1
        for x = 2 : width - 1
            if I(y, x) == 0
                % Eliminable.
                eliminable = 0;
                patch = I(y - 1 : y + 1, x - 1 : x + 1);
                black_num = sum(sum(patch == 0));
                if 3 <= black_num && black_num <= 8
                    masks = ELIMINATION_MASK{black_num};
                    code = elimination_mask_encoding(patch);
                    for k = 1 : length(masks)
                        if masks(k) == code
                            eliminable = 1;
                            break
                        end
                    end
                end
                % Preservable.
                if eliminable == 1
                    for k = 1 : length(PRESEVERED_MASK)
                        mask = PRESEVERED_MASK{k};
                        [mask_height, mask_width] = size(mask);
                        mask_y = PRESEVERED_MASK_CENTROID(k, 1);
                        mask_x = PRESEVERED_MASK_CENTROID(k, 2);
                        if y >= mask_y && x >= mask_x
                            if y + mask_height - mask_y <= height && x + mask_width - mask_x <= width
                                preservable = 1;
                                patch = I(y - mask_y + 1 : y + mask_height - mask_y, x - mask_x + 1 : x + mask_width - mask_x);
                                for row = 1 : mask_height
                                    for col = 1 : mask_width
                                        if mask(row, col) ~= 2 && mask(row, col) ~= patch(row, col)
                                            preservable = 0;
                                            break
                                        end
                                    end
                                end
                                if preservable == 1
                                    eliminable = 0;
                                    break
                                end
                            end
                        end
                    end
                end
                % Eliminate.
                if eliminable == 1
                    eliminated = eliminated + 1;
                else
                    Ith(y, x) = 0;
                end
            end
        end
    end
    if eliminated == 0
        break
    end
    I = Ith;
end