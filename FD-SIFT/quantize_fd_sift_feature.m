function Quantized = quantize_fd_sift_feature(Features, Center)
% Features should be (28 * 28)-by-(4 * 4 * 4)-by-N.
% Center should be K-by-(4 * 4 * 4).
% Quantized should be N-by-K.
N = size(Features, 3);
K = size(Center, 1);
Quantized = zeros([N, K]);
for i = 1 : N
    for j = 1 : 28 * 28
        for k = 1 : K
            Dist = exp(-norm(Features(j, : , i) - Center(k, :)) / 2 * 0.1 ^ 1);
            Quantized(i, k) = Quantized(i, k) + Dist;
        end
    end
end
Quantized = Quantized / (28 * 28);
