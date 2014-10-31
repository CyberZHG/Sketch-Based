for i = 0 : 40
    name = [num2str(i), '.jpg'];
    I = imread(name);
    if size(I, 3) > 1
        I = rgb2gray(I);
    end
    I = imresize(I, [200, 200]);
    if i > 0
        I = 1 - edge(I, 'canny');
    end
    imwrite(I, name);
end