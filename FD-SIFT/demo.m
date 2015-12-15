Image = imread('test.jpg');
Feature = extract_fd_sift_feature(Image);
Visual = visual_fd_sift_feature(Feature);
imwrite(Visual, 'visual.jpg');