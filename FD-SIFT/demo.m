Image = imread('test.jpg');
Feature = extract_fd_sift_feature(Image);
% Visual = visual_fd_sift_feature(Feature);
% imwrite(Visual, 'visual.jpg');

Features(:, :, 1) = Feature;
Features(:, :, 2) = Feature;
Features(:, :, 3) = Feature;
Center = cluster_fd_sift_feature(Features, 100);
Quantized = quantize_fd_sift_feature(Features, Center);
