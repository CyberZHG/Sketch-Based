function Visual = vis_sampling(Image, Location)
Height = size(Image, 1);
Width = size(Image, 2);
Visual = ones(Height, Width, 'double');
for k = 1 : size(Location, 2)
    for dr = -2 : 2
        for dc = -2 : 2
            if dr == 0 || dc == 0
                tr = Location(1, k) + dr;
                tc = Location(2, k) + dc;
                if tr < 1 || tr > Height
                    continue
                end
                if tc < 1 || tc > Width
                    continue
                end
                Visual(tr, tc) = 0.0;
            end
        end
    end
end
