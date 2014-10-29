function result = edgel_query(query_image, index, image_path)
    score = [];
    map = generate_hit_map(query_image);
    for x = 1 : 200
        for y = 1 : 200
            for theta = 1 : 6
                if map(x, y, theta) == 1
                    for k = 1 : length(index{x, y, theta});
                        if index{x, y, theta}(k) > length(score)
                            score(index{x, y, theta}(k)) = 1;
                        else
                            score(index{x, y, theta}(k)) = score(index{x, y, theta}(k)) + 1;
                        end
                    end
                end
            end
        end
    end
    for i = 1 : length(score)
        if score(i) > 0
            sketch = imread(image_path{i});
            map = generate_hit_map(sketch);
            reverse_score = 0;
            for x = 1 : 200
                for y = 1 : 200
                    for theta = 1 : 6
                        if map(x, y, theta) == 1
                            if query_image(x, y) == 0 % Should be angle.
                                reverse_score = reverse_score + 1;
                            end
                        end
                    end
                end
            end
            score(i) = score(i) * reverse_score;
        end
    end
    result = 1 : length(score);
    for i = 1 : length(score)
        for j = i + 1 : length(score)
            if score(i) < score(j)
                temp = result(i);
                result(i) = result(j);
                result(j) = temp;
                temp = score(i);
                score(i) = score(j);
                score(j) = temp;
            end
        end
    end
end