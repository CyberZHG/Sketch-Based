function edgel_index = generate_index(image_id, image_path)
    % GENERATE_INDEX Generate inverted hit map index of database images.
    %
    %   INDEX = GENERATE_INDEX(IMAGE_ID, IMAGE_PATH) IMAGE_PATH is a 
    %   vector of locations of database image file. The function returns
    %   200 * 200 * 6 cells, each cell contain a vector of the associated
    %   IMAGE_ID.
    edgel_index = cell([200, 200, 6]);
    for x = 1 : 200
        for y = 1 : 200
            for theta = 1 : 6
                edgel_index{x, y, theta} = [];
            end
        end
    end
    for i = 1 : length(image_path)
        sketch = imread(image_path{i});
        if size(sketch, 3) > 1
            sketch = rgb2gray(sketch);
        end
        sketch = imresize(sketch, [200 200]);
        map = generate_hit_map(sketch);
        visualize_hit_map(sketch);
        drawnow;
        for x = 1 : 200
            for y = 1 : 200
                for theta = 1 : 6
                    if map(x, y, theta) == 1
                        edgel_index{x, y, theta}(end + 1) = image_id(i);
                    end
                end
            end
        end
    end
end