Image_1 = imread('test.jpg');
Height = size(Image_1, 1);
Width = size(Image_1, 2);
Locations_1 = sampling(Image_1, 4);
Feature_1 = extract_hoosc_feature(Image_1, Locations_1, min([Height, Width]) * 0.5, 8);

Image_2 = flip(Image_1, 2);
Locations_2 = sampling(Image_2, 4);
Feature_2 = extract_hoosc_feature(Image_2, Locations_2, min([Height, Width]) * 0.5, 8);

K = 100;
[Idx, C] = kmeans([Feature_1'; Feature_2'], K);
Idx_1 = Idx(1:size(Feature_1, 2));
Idx_2 = Idx((size(Feature_1, 2) + 1):end);
compare_hoose_feature(Idx_1, Idx_2, K);
