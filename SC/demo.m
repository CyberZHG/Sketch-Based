Image_1 = imread('test.jpg');
Height = size(Image_1, 1);
Width = size(Image_1, 2);
Locations_1 = sampling(Image_1, 4);
Visual_1 = vis_sampling(Image_1, Locations_1);
Feature_1 = extract_sc_feature(Locations_1, min([Height, Width]) * 0.5);

Image_2 = flip(Image_1, 2);
Locations_2 = sampling(Image_2, 4);
Visual_2 = vis_sampling(Image_2, Locations_2);
Feature_2 = extract_sc_feature(Locations_2, min([Height, Width]) * 0.5);

[Dist, Matches] = match_sc_feature(Feature_1, Feature_2, 3);

Image_1 = imresize(Image_1, 2.0);
Image_2 = imresize(Image_2, 2.0);
Locations_1 = Locations_1 * 2;
Locations_2 = Locations_2 * 2;
Visual = vis_matching_result(Image_1, Image_2, Locations_1, Locations_2, Matches);
imshow(Visual);
