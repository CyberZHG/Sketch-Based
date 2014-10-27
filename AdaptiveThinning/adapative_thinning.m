function Ith_best = adapative_thinning(I)
% ADAPATIVE_THINNING Produce thinned version of the input sketch image.
%
%   ITH_BEST = ADAPATIVE_THINNING(I) produce a one-pixel-wide skeleton
%   visually similar to the original image, and preserve connectivity
%   between foreground pixels. The input sketch should be a binarized or
%   gray-scale image with only one channel, and the skeleton should be
%   represented by black pixels.

SIGMA_MIN = 3;
SIGMA_INC = 2;
SIGMA_MAX = 17;
POSITION = [0, 0; -1, -1; -1, 0; -1, 1; 0, 1; 1, 1; 1, 0; 1, -1; 0, -1; 0, 0];

i = 0;
[height, width] = size(I);
S_min = height * width + 1;
% figure;
for sigma = SIGMA_MIN : SIGMA_INC : SIGMA_MAX
    i = i + 1;
    % Gaussian filter.
    filter = fspecial('gaussian', sigma, sigma);
    IG = imfilter(I, filter, 'same');
    % Adaptive binarization.
    th = 1.0 * sum(sum(uint8(IG) .* uint8(IG ~= 255))) / sum(sum(IG ~= 255));
    IB = 1 - (IG < th);
    % Thinning algorithm.
    Ith = thinning(IB);
    % Sensitivity measure.
    S = 0;
    for y = 2 : height - 1
        for x = 2 : width - 1
            if Ith(y, x) == 1 && I(y, x) == 0
                S = S + 1;
            else
                transition = 0;
                for k = 1 : 8
                    Pk = Ith(y + POSITION(k, 1), x + POSITION(k, 2));
                    Pk_1 = Ith(y + POSITION(k + 1, 1), x + POSITION(k + 1, 2));
                    if Pk == 1 && Pk_1 == 0
                        transition = transition + 1;
                        if transition > 2
                            break
                        end
                    end
                end
                if transition > 2
                    S = S + 1;
                end
            end
        end
    end
    if S < S_min
        S_min = S;
        Ith_best = Ith;
    end
end