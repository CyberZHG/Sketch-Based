function Feature = extract_grid_hog(Image, Num, Bin)
    % Feature: (Num * Num * Bin) x 1 vector.
    if nargin == 2
        Bin = 8;
    end
    Height = size(Image, 1);
    Width = size(Image, 2);
    RowLength = Height / Num;
    ColLength = Width / Num;
    Feature = zeros([Bin * Num * Num, 1]);
    for R = 1 : Num
        for C = 1 : Num
            Patch = Image(floor((R - 1) * RowLength) + 1 : floor(R * RowLength), ...
                          floor((C - 1) * ColLength) + 1 : floor(C * ColLength));
            Start = ((R - 1) * Num + C - 1) * Bin + 1;
            End = Start + Bin - 1;
            Feature(Start : End) = extract_hog(Patch, Bin);
        end
    end
end