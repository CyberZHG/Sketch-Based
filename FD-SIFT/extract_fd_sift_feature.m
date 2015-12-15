function Feature = extract_fd_sift_feature(Image)
% Feature is a (28 * 28)-by-(4 * 4 * 4) matrix. Each row is a SIFT feature.
ImageSize = 256;
PointNum = 28;
Margin = ImageSize / PointNum;
PatchSize = ImageSize / 8;
HalfPatchSize = PatchSize / 2;
QuarterPatchSize = HalfPatchSize / 2;
GridNum = 4;
BinNum = 4;
Feature = zeros([28 * 28, 4 * 4 * 4]);
if size(Image, 3) > 1
    Image = rgb2gray(Image);
end
Image = im2double(Image);
Image = imresize(Image, [ImageSize ImageSize]);
Py = imfilter(Image, [-1, -1; 1, 1]);
Px = imfilter(Image, [-1, 1; -1, 1]);
Amplitude = sqrt(Px .* Px + Py .* Py);
Interval = pi / BinNum;
Angle = mod(round((atan2(Py, Px) + 4 * pi) / Interval), BinNum) + 1;
for i = 0 : 27
    Cr = round(Margin * 0.5 + i * Margin);
    for j = 0 : 27
        Cc = round(Margin * 0.5 + j * Margin);
        Index = i * 28 + j + 1;
        for r = (Cr - HalfPatchSize):(Cr + HalfPatchSize)
            if r < 1 || r > ImageSize
                continue
            end
            Gr = min([floor((r - (Cr - HalfPatchSize)) / QuarterPatchSize), GridNum - 1]);
            for c = (Cc - HalfPatchSize):(Cc + HalfPatchSize)
                if c < 1 || c > ImageSize
                    continue
                end
                Gc = min([floor((c - (Cc - HalfPatchSize)) / QuarterPatchSize), GridNum - 1]);
                GridIndex = (Gr * GridNum + Gc) * BinNum;
                BinIndex = GridIndex + Angle(r, c);
                Feature(Index, BinIndex) = Feature(Index, BinIndex) + Amplitude(r, c);
            end
        end
    end
end
Feature = Feature / (max(max(Feature)) + 1e-8);
