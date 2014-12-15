function Feature = extract_ap(Sketch, AngleBinNum, NormBinNum)
    if nargin == 1
        AngleBinNum = 12;
        NormBinNum = 5;
    end
    if size(Sketch, 3) > 1
        Sketch = rgb2gray(Sketch);
    end
    Sketch = im2double(Sketch);
    Height = size(Sketch, 1);
    Width = size(Sketch, 2);
    CenterX = Height * 0.5;
    CenterY = Width * 0.5;
    AngleLen = pi * 2.0 / AngleBinNum;
    NormLen = max([CenterX, CenterY]) * sqrt(2.0) / NormBinNum  + 0.01;
    [Rows, Cols] = find(Sketch > 0.5);
    AngleBin = mod(floor((atan2(Cols - CenterY, Rows - CenterX) + 4 * pi) / AngleLen), AngleBinNum);
    NormBin = floor(sqrt((Rows - CenterX) .^ 2 + (Cols - CenterY) .^ 2) / NormLen);
    Index = NormBin * AngleBinNum + AngleBin + 1;
    Histogram = reshape(hist(Index, AngleBinNum * NormBinNum), [AngleBinNum, NormBinNum])/ length(Rows);
    Feature = reshape(abs(fft(Histogram)), [AngleBinNum * NormBinNum, 1]);
end