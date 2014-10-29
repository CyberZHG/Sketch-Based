image_id = 1 : 40;
image_path = {};
for i = 1 : length(image_id)
    image_path{end + 1} = [num2str(image_id(i)) '.jpg'];
%     I = imread(image_path{end});
%     if size(I, 3) > 1
%         I = rgb2gray(I);
%     end
%     I = edge(I, 'canny');
%     imwrite(1 - I, image_path{end});
end
%edgel_index = generate_index(image_id, image_path);
%save('index.mat', 'edgel_index');
%load('index.mat', 'edgel_index');
query_image = imread('query.png');
result = edgel_query(query_image, edgel_index, image_path);
for i = 1 : 5
    for j = 1 : 5
        subplot(5, 5, (i - 1) * 5 + j);
        I = imread([num2str(result((i - 1) * 5 + j)), '.jpg']);
        imshow(I);
    end
end