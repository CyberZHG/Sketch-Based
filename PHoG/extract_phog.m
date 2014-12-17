function Feature = extract_phog(Image, LayerNum, Bin)
    if nargin == 2
        Bin = 8;
    end
    TotalNum = 0;
    Temp = 1;
    for i = 1 : LayerNum
        TotalNum = TotalNum + Temp;
        Temp = Temp * 4;
    end
    Feature = zeros([TotalNum * Bin, 1]);
    Index = 1;
    Temp = 1;
    for i = 1 : LayerNum
        Length = Temp * Bin;
        Feature(Index : Index + Length - 1) = extract_grid_hog(Image, 2 ^ (i - 1), Bin);
        Index = Index + Length;
        Temp = Temp * 4;
    end
end