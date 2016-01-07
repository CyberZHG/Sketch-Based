function Feature = extract_d(Image)
% Feature: (S x S x R x P)-by-1
S = 4;
R = 9;
SP = 28;
P = 28 * 28;
Feature = zeros([P, S * S * R]);
if size(Image, 3) > 1
    Image = rgb2gray(Image);
end
Image = 1.0 - im2double(Image);
[Height, Width] = size(Image);
PatchSize = min([Height, Width]) / 8;
Responses = zeros([Height, Width, R]);
for K = 1 : R
    Filter = gabor_filter(4, 5, pi / R * (K - 1), 0.0, 0.56 * 5, 1.0);
    Response = imfilter(Image, Filter);
    Responses(:, :, K) = Response;
end
Responses = Responses - Responses .* (Responses < 0);
Responses = Responses / ((max(max(max(Responses)))) + 1e-8);
for I = 1 : SP
    for J = 1 : SP
        CenterY = round(Height / SP / 2 + (I - 1) * (Height / SP));
        CenterX = round(Width / SP / 2 + (J - 1) * (Width / SP));
        Index = (I - 1) * SP + J;
        Feature(Index, :) = extract_dj(Responses, CenterY, CenterX, PatchSize);
    end
end
