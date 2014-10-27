I = imread('test.jpg');
I = rgb2gray(I);
Ith_best = adapative_thinning(I > 230);
imwrite(Ith_best, 'result.jpg', 'PNG');