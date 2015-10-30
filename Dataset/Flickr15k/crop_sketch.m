function crop_sketch(InputPath, OutputPath, OutputSize)
    Image = imread(InputPath);
    if size(Image, 3) > 1
        Image = rgb2gray(Image);
    end
    Image = im2double(Image);
    Height = size(Image, 1);
    Width = size(Image, 2);
    CenterH = 0.0;
    CenterW = 0.0;
    PixelNum = 0;
    for i = 1 : Height
        for j = 1 : Width
            if Image(i, j) < 0.5
                PixelNum = PixelNum + 1;
                CenterH = CenterH + i;
                CenterW = CenterW + j;
            end
        end
    end
    if PixelNum > 0
        CenterH = CenterH / PixelNum;
        CenterW = CenterW / PixelNum;
    end
    AveDist = 0.0;
    for i = 1 : Height
        for j = 1 : Width
            if Image(i, j) < 0.5
                AveDist = AveDist + sqrt((i - CenterH) ^ 2 + (j - CenterW) ^ 2);
            end
        end
    end
    AveDist = AveDist / PixelNum;
    Length = min([1.5 * AveDist, CenterH, CenterW, Height - CenterH, Width - CenterW]) - 1.0;
    Image = Image(int32(CenterH - Length):int32(CenterH + Length), int32(CenterW - Length):int32(CenterW + Length));
    Image = imresize(Image, OutputSize);
    imwrite(Image, OutputPath);
end