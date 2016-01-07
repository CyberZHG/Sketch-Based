function Feature = extract_dj(Responses, CenterX, CenterY, PatchSize)
% Feature: (S x S x R)-by-1
S = 4;
R = 9;
Feature = zeros([S * S * R, 1]);
for I = 1 : R
    Begin = (I - 1) * S * S + 1;
    End = I * S * S;
    Feature(Begin:End) = extract_hij(Responses(:, :, I), CenterX, CenterY, PatchSize);
end
Feature = Feature / (norm(Feature) + 1e-8);
