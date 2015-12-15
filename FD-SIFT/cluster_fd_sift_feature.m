function Center = cluster_fd_sift_feature(Features, K)
% Features should be (28 * 28)-by-(4 * 4 * 4)-by-N.
% Center should be K-by-(4 * 4 * 4).
N = size(Features, 3);
Aligned = zeros([28 * 28 * N, 4 * 4 * 4]);
for i = 1 : N
    Begin = (i - 1) * 28 * 28 + 1;
    End = i * 28 * 28;
    Aligned(Begin:End, :) = Features(:, :, i);
end
[~, Center] = kmeans(Aligned, K);
