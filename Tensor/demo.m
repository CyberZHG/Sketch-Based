I = imread('test.jpg');
desc = tensor_extract(I, [16, 20]);
vis = tensor_visualization(I, [16, 20]);
imwrite(vis, 'result.jpg');
imshow(vis);