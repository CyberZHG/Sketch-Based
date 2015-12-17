Image = imread('cameraman.tif');
if size(Image, 3) > 1
    Image = rgb2gray(Image);
end
Image = im2double(Image);
subplot(2, 3, 1);
imshow(Image);

Filter_0 = gabor_filter(9, 3.5, 0.0, 0.0, 0.56 * 3.5, 0.5);
Image_0 = imfilter(Image, Filter_0);
Image_0 = Image_0 / ((max(max(Image_0))) + 1e-8);
subplot(2, 3, 2);
imshow(Image_0);

Filter_45 = gabor_filter(9, 3.5, pi / 4, 0.0, 0.56 * 3.5, 0.5);
Image_45 = imfilter(Image, Filter_45);
Image_45 = Image_45 / ((max(max(Image_45))) + 1e-8);
subplot(2, 3, 3);
imshow(Image_45);

Filter_90 = gabor_filter(9, 3.5, pi / 2, 0.0, 0.56 * 3.5, 0.5);
Image_90 = imfilter(Image, Filter_90);
Image_90 = Image_90 / ((max(max(Image_90))) + 1e-8);
subplot(2, 3, 5);
imshow(Image_90);

Filter_135 = gabor_filter(9, 3.5, pi * 3 / 4, 0.0, 0.56 * 3.5, 0.5);
Image_135 = imfilter(Image, Filter_135);
Image_135 = Image_135 / ((max(max(Image_135))) + 1e-8);
subplot(2, 3, 6);
imshow(Image_135);

Image_All = Image_0 + Image_45 + Image_90 + Image_135;
Image_All = Image_All / ((max(max(Image_All))) + 1e-8);
subplot(2, 3, 4);
imshow(Image_All);
