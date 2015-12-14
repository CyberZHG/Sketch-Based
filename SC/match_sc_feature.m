function [Dist, Matches] = match_sc_feature(Feature1, Feature2, Dummy)
% MATCH_SC_FEATURE Match the Shape Context feature.
%
%   [DIST, MATCHES] = MATCH_SC_FEATURE(FEATURE1, FEATURE2, Dummy) returns
%   the distance and matched points. MATCHES has the same number of columns
%   with FEATURE2, in which 0 means there is no matched point in FEATURE1,
%   while a positive number means the index of the matched point in
%   FEATURE1. DUMMY is the cost for the points with no matches.
N = size(Feature1, 2);
M = size(Feature2, 2);
Matches = zeros([1, M]);
Dists = zeros([N, M]);
for i = 1 : N
    for j = 1 : M
        Dists(i, j) = dist_sc_feature(Feature1(:, i), Feature2(:, j));
    end
end
for i = 1 : N
    [~, Matches, ~] = find_sc_feature(i, Dists, Matches, zeros([1, M]), Dummy);
end
Dist = 0.0;
for j = 1 : M
    if Matches(j) == 0
        Dist = Dist + Dummy;
    else
        Dist = Dist + Dists(Matches(j), j);
    end
end
if N > M
    Dist = Dist + (M - N) * Dummy;
end
