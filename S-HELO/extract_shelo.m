function feature = extract_shelo(I, W, B, K)
    % W: number of cells per direction.
    % B: number of blocks per direction.
    % K: histogram size.
    % Feature: B x B x K.
    if nargin == 1
        W = 25;
        B = 6;
        K = 36;
    end
    M = size(I, 1);
    N = size(I, 2);
    if B > 1
        feature = zeros([B * B * K, 1]);
        index = 1;
        block_row = floor(M / B);
        block_col = floor(N / B);
        for i = 1 : B
            for j = 1 : B
                Patch = I((i - 1) * block_row + 1 : i * block_row, ...
                          (j - 1) * block_col + 1 : j * block_col);
                feature(index : index + K - 1) = extract_shelo(Patch, W, 1, K);
                index = index + K;
            end
        end
        feature = (feature - min(feature)) / (max(feature) - min(feature) + 1e-6);
    else
        Gi = imfilter(I, [1 2 1; 0 0 0; -1 -2 -1]);
        Gj = imfilter(I, [-1 0 1; -2 0 2; -1 0 1]);
        Gsi = 2 * Gj .* Gi;
        Gsj = Gj .^ 2 - Gi .^ 2;
        weight = sqrt(Gsi .^ 2 + Gsj .^ 2);
        theta = atan2(Gsj, Gsi);
        A = zeros([W, W]);
        D = zeros([W, W]);
        magnitude = zeros([W, W]);
        for i = 1 : M
            for j = 1 : N
                p = j / N * W;
                q = i / M * W;
                l_pos = ceil(p - 0.5);
                r_pos = ceil(p + 0.5);
                n_pos = ceil(q - 0.5);
                s_pos = ceil(q + 0.5);
                if r_pos > W
                    r_pos = W;
                end
                if s_pos > W
                    s_pos = W;
                end
                dist_p = p - floor(p);
                dist_q = q - floor(q);
                if dist_p < 0.5
                    l_weight = 0.5 - dist_p;
                    r_weight = 1.0 - l_weight;
                else
                    r_weight = dist_p - 0.5;
                    l_weight = 1.0 - r_weight;
                end
                if dist_q < 0.5
                    n_weight = 0.5 - dist_q;
                    s_weight = 1.0 - n_weight;
                else
                    s_weight = dist_q - 0.5;
                    n_weight = 1.0 - s_weight;
                end
                x = [l_pos; r_pos; l_pos; r_pos];
                y = [n_pos; n_pos; s_pos; s_pos];
                wx = [l_weight; r_weight; l_weight; r_weight];
                wy = [n_weight; n_weight; s_weight; s_weight];
                alpha = wx .* wy;
                index = sub2ind([W, W], x, y);
                A(index) = A(index) + alpha * 2 * sin(theta(i, j)) * cos(theta(i, j));
                D(index) = D(index) + alpha * (cos(theta(i, j)) ^ 2 - sin(theta(i, j)) ^ 2);
                magnitude(index) = magnitude(index) + weight(i, j);
            end
        end
        beta = 0.5 * atan2(A, D);
        bin = mod(floor((beta + 4 * pi) / (2 * pi / K)), K) + 1;
        feature = zeros([K, 1]);
        for i = 1 : W;
            for j = 1 : W
                feature(bin(i, j)) = feature(bin(i, j)) + magnitude(i, j);
            end
        end
    end
end