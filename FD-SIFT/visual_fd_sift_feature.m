function Visual = visual_fd_sift_feature(Features)
PatchSize = 256;
PointNum = 28;
ImageSize = PatchSize * PointNum;
GridNum = 4;
BinNum = 4;
GridSize = PatchSize / GridNum;
BinSize = (GridSize - 1) / 2;
Visual = zeros(ImageSize);
for i = 0 : 27
    Sr = i * PatchSize + 1;
    if i > 0 
        Visual = draw_line(Visual, 1, Sr, ImageSize, Sr);
        Visual = draw_line(Visual, Sr, 1, Sr, ImageSize);
    end
    for j = 0 : 27
        Index = i * 28 + j + 1;
        Feature = Features(Index, :);
        Sc = j * PatchSize + 1;
        for gi = 0 : 3
            Gr = Sr + gi * GridSize;
            Cr = round(Gr + GridSize / 2);
            for gj = 0 : 3
                Gc = Sc + gj * GridSize;
                Cc = round(Gc + GridSize / 2);
                GridIndex = (gi * GridNum + gj) * BinNum;
                for k = 1 : BinNum
                    BinIndex = GridIndex + k;
                    Mr = Feature(BinIndex) * BinSize * cos(pi / BinNum * (k - 1));
                    Mc = Feature(BinIndex) * BinSize * sin(pi / BinNum * (k - 1));
                    Visual = draw_line(Visual, Cr + Mr, Cc + Mc, Cr - Mr, Cc - Mc);
                end
            end
        end
    end
end
