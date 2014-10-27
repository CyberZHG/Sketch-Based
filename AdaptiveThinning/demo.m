I = imread('47.png');
I = rgb2gray(I);
Ith_best = adapative_thinning(I);

subplot(1, 2, 1); 
imshow(I); 
subplot(1, 2, 2); 
imshow(Ith_best);