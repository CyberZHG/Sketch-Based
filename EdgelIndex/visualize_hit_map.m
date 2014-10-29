function visualize_hit_map(sketch)
    COLOR_SKETCH = [237, 32, 36];
    COLOR_HITMAP = [173, 213, 128];
    COLOR_BACKGROUND = [255, 255, 255];
    map = generate_hit_map(sketch);
    sketch = imresize(sketch, [200 200]);
    sketch = sketch > (max(max(sketch)) * 0.7 + min(min(sketch)) * 0.3);
    for k = 1 : 6
        vis = uint8(zeros([200, 200, 3]));
        for i = 1 : 200
            for j = 1 : 200
                if sketch(i, j) == 0
                    vis(i, j, :) = COLOR_SKETCH;
                elseif map(i, j, k) == 1
                    vis(i, j, :) = COLOR_HITMAP;
                else
                    vis(i, j, :) = COLOR_BACKGROUND;
                end
            end
        end
        subplot(2, 3, k);
        imshow(vis);
        title(['Angle:' num2str((k - 1) * 30 - 15) ' ~ ' num2str((k - 1) * 30 + 15)]);
    end
end