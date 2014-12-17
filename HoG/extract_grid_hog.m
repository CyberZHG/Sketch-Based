function Feature = extract_grid_hog(Image, Num, Bin)
    % Feature: (Num * Num * Bin) x 1 vector.
    if nargin == 2
        Bin = 9;
    end
    Height = size(Image, 1);
    Width = size(Image, 2);
    RowLength = Height / Num;
    ColLength = Width / Num;
    Feature = zeros([Num * Num * Bin, 1]);
    Px = imfilter(Image, [-1 -2 -1; 0 0 0; 1 2 1]);
    Py = imfilter(Image, [-1 0 1; -2 0 2; -1 0 1]);
    Amplitude = sqrt(Px .* Px + Py .* Py);
    Angle = mod(floor((atan2(Py, Px) + pi * 4) / (pi / Bin)), Bin);
    for i = 1 : Height
        for j = 1 : Width
            Row = floor((i - 1) / RowLength);
            Col = floor((j - 1) / ColLength);
            Index = (Row * Num + Col) * Bin + Angle(i, j) + 1;
            Feature(Index) = Feature(Index) + Amplitude(i, j);
        end
    end
end