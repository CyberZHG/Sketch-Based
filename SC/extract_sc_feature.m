function Feature = extract_sc_feature(Locations, Range)
% EXTRACT_SC_FEATURE Produce the Shape Context feature.
%
%   FEATURE = EXTRACT_SC_FEATURE(LOCATIONS, RANGE) produce a 60 x N matrix,
%   each column is the Shape Context feature of corresponding sampled
%   point. RANGE is the radius of the Shape Context feature.
N = size(Locations, 2);
Feature = zeros(60, N);
for i = 1 : N
    ri = Locations(1, i);
    ci = Locations(2, i);
    for j = 1 : N
        if i ~= j
            rj = Locations(1, j);
            cj = Locations(2, j);
            Dist = norm([ri - rj, ci - cj]);
            R = ceil(log(Dist) / log(Range) * 5);
            if 1 <= R && R <= 5
                Angle = atan2(cj - ci, rj - ri);
                if Angle < 0.0
                    Angle = Angle + pi * 2;
                end
                A = floor(Angle / (pi / 6));
                Index = (R - 1) * 12 + 1 + A;
                Feature(Index, i) = Feature(Index, i) + 1;
            end
        end
    end
    Feature(:, i) = Feature(:, i) / (max(Feature(:, i)) + 1e-8);
end
