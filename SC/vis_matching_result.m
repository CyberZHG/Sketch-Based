function Visual = vis_matching_result(Image1, Image2, Location1, Location2, Matches)
Height = size(Image1, 1);
Width = size(Image1, 2);
Visual = ones(Height, Width, 3, 'double');
Visual(:, :, 1) = vis_sampling(Image1, Location1);
Visual(:, :, 2) = vis_sampling(Image2, Location2);
for k = 1 : length(Matches)
    if Matches(k) > 0
        Visual(:, :, 3) = draw_line(Visual(:, :, 3), ...
            Location1(1, Matches(k)), Location1(2, Matches(k)), ...
            Location2(1, k), Location2(2, k));
    end
end
for i = 1 : Height
    for j = 1 : Width
        if Visual(i, j, 1) < 0.5
            Visual(i, j, 1) = 1.0;
            Visual(i, j, 2) = 0.0;
            Visual(i, j, 3) = 0.0;
        elseif Visual(i, j, 2) < 0.5
            Visual(i, j, 1) = 0.0;
            Visual(i, j, 2) = 0.5;
            Visual(i, j, 3) = 0.0;
        elseif Visual(i, j, 3) < 0.5
            Visual(i, j, 1) = 0.5;
            Visual(i, j, 2) = 0.5;
            Visual(i, j, 3) = 1.0;
        end
    end
end
