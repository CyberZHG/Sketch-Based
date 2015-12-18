function Feature = extract_d(Image)
% Feature: (S x S x R x P)-by-1
S = 4;
R = 9;
SP = 28;
P = 28 * 28;
Feature = zeros([S * S * R * P, 1]);
if size(Image, 3) > 1
    Image = rgb2gray(Image);
end
Image = im2double(Image);
[Height, Width] = size(Image);
PatchSize = min([Height, Width]) / 8;
Responses = zeros([Height, Width, R]);
for K = 1 : R
    Filter = gabor_filter(4, 10, pi / R * (K - 1), 0.0, 0.56 * 10, 1.0);
    Response = imfilter(Image, Filter);
    Response = Response - Response .* (Response < 0);
    Response = Response / ((max(max(Response))) + 1e-8);
    Responses(:, :, K) = Response;
end
for I = 1 : SP
    for J = 1 : SP
        CenterY = round(Height / SP / 2 + (I - 1) * (Height / SP));
        CenterX = round(Width / SP / 2 + (J - 1) * (Width / SP));
        Index = (I - 1) * SP + J;
        Begin = (Index - 1) * S * S * R + 1;
        End = Index * S * S * R;
        Feature(Begin:End) = extract_dj(Responses, CenterY, CenterX, PatchSize);
    end
end
