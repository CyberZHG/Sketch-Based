I = imread('test.jpg');
I = rgb2gray(I);
Ith_best = adapative_thinning(I > 230);

figure;
imshow(I); 
figure;
imshow(Ith_best);