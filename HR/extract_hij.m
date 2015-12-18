function Feature = extract_hij(Response, CenterX, CenterY, PatchSize)
% Feature: (S x S)-by-1
S = 4;
Feature = zeros([S * S, 1]);
[Height, Width] = size(Response);
HalfPatchSize = floor(PatchSize / 2);
BinSize = PatchSize / S;
for Y = CenterY - HalfPatchSize : CenterY + HalfPatchSize
    for X = CenterX - HalfPatchSize : CenterX + HalfPatchSize
        if 1 <= Y && Y <= Height
            if 1 <= X && X <= Width
                BinY = floor((Y - (CenterY - HalfPatchSize)) / BinSize);
                BinX = floor((X - (CenterX - HalfPatchSize)) / BinSize);
                if BinY >= S
                    BinY = S - 1;
                end
                if BinX >= S
                    BinX = S - 1;
                end
                Index = BinY * 4 + BinX + 1;
                Feature(Index) = Feature(Index) + Response(Y, X);
            end
        end
    end
end
