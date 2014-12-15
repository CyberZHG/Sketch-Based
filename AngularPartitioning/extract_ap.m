function Feature = extract_ap(Sketch, BinNum)
    if nargin < 2
        BinNum = 12;
    end
    if size(Sketch, 3) > 1
        Sketch = rgb2gray(Sketch);
    end
    Sketch = im2double(Sketch);
    CenterX = size(Sketch, 1) * 0.5;
    CenterY = size(Sketch, 2) * 0.5;
    AngleLen = pi * 2.0 / BinNum;
    [Rows, Cols] = find(Sketch > 0.5);
    Index = mod(floor((atan2(Cols - CenterY, Rows - CenterX) + 4 * pi) / AngleLen), BinNum) + 1;
    Feature = abs(fft(hist(Index, BinNum)' / length(Index)));
end