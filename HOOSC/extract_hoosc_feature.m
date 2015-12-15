function Feature = extrct_hoosc_feature(Image, Locations, Range, BinNum)
% EXTRACT_HOOSC_FEATURE Produce the Histogram of Orientation Shape Context
% feature.
%
%   FEATURE = EXTRACT_HOOSC_FEATURE(IMAGE, LOCATIONS, RANGE, BINNUM) produce 
%   a (60 * BinNum) x N matrix, each column is the HOOSC feature of corresponding 
%   sampled point. RANGE is the radius of the Shape Context feature. BINNum
%   is the number of orientations in each spatial bin.
N = size(Locations, 2);
Feature = zeros(60 * BinNum, N);
if size(Image, 3) > 1
    Image = rgb2gray(Image);
end
Image = im2double(Image);
Py = imfilter(Image, [-1, -1; 1, 1]);
Px = imfilter(Image, [-1, 1; -1, 1]);
Angles = atan2(Py, Px);
Angles = Angles + (Angles < 0.0) * 2 * pi;
Angles = imfilter(Angles, ones(3) / 9);
for i = 1 : N
    ri = Locations(1, i);
    ci = Locations(2, i);
    for j = 1 : N
        if i ~= j
            rj = Locations(1, j);
            cj = Locations(2, j);
            Dist = norm([ri - rj, ci - cj]);
            R = ceil(log(Dist) / log(Range)) * 5;
            if 1 <= R && R <= 5
                Angle = atan2(cj - ci, rj - ri);
                if Angle < 0.0
                    Angle = Angle + pi * 2;
                end
                A = floor(Angle / (pi / 6));
                Index = ((R - 1) * 12 + A) * BinNum;
                for k = 1 : BinNum
                    Center = 2 * pi / BinNum * k;
                    Feature(Index + k, i) = Feature(Index + k, i) + ...
                        exp(-angle_dist(Angles(rj, cj), Center) ^ 2 / (2 * 10 ^ 2));
                end
            end
        end
    end
    for j = 1 : 5
        Begin = (j - 1) * 12 * BinNum + 1;
        End = j * 12 * BinNum;
        Feature(Begin:End, i) = Feature(Begin:End, i) / (max(Feature(Begin:End, i)) + 1e-8);
    end
end
