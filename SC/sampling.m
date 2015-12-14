function Locations = sampling(Image, Margin)
% SAMPLING Produce the locations of uniformly sampled points.
%
%   LOCATIONS = SAMPLING(IMAGE, MARGIN) produce a 2 x N matrix, in which each 
%   column is a sampled location. MARGIN is the distance between two
%   sampled points.
if size(Image, 3) > 1
    Image = rgb2gray(Image);
end
Image = im2double(Image);
[Height, Width] = size(Image);
Quad = max([floor(Margin / 4), 1]);
Locations = zeros(2, Height * Width);
Index = 0;
for r = Margin : Margin : Height - Margin
    for c = Margin : Margin : Width - Margin
        Nearest = 1e100;
        Found = false;
        nr = -1;
        nc = -1;
        for dr = -Quad : Quad : Quad
            for dc = -Quad : Quad : Quad
                tr = r + dr;
                tc = c + dc;
                if tr < 1 || tr > Height
                    continue
                end
                if tc < 1 || tc > Width
                    continue
                end
                if Image(tr, tc) < 0.5
                    if norm([tr, tc]) < Nearest
                        Nearest = norm([tr, tc]);
                        Found = true;
                        nr = tr;
                        nc = tc;
                    end
                end
            end
        end
        if Found
            Index = Index + 1;
            Locations(:, Index) = [nr nc];
        end
    end
end
Locations = Locations(:, 1:Index);
