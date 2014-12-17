function Feature = extract_hog(Image, Bin)
    % Feature: Bin x 1 vector.
    if nargin == 1
        Bin = 8;
    end
    if size(Image, 3) > 1
        Image = rgb2gray(Image);
    end
    Image = im2double(Image);
    Py = imfilter(Image, [-1, -1; 1, 1]);
    Px = imfilter(Image, [-1, 1; -1, 1]);
    Amplitude = sqrt(Px .* Px + Py .* Py);
    Interval = pi / Bin;
    Angle = mod(round((atan2(Py, Px) + 4 * pi) / Interval), Bin) + 1;
    Feature = zeros([Bin, 1]);
    for i = 1 : size(Amplitude, 1)
        for j = 1 : size(Amplitude, 2)
            if Amplitude(i, j) > 1e-4
                Feature(Angle(i, j)) = Feature(Angle(i, j)) + Amplitude(i, j);
            end
        end
    end
end