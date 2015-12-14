function Dist = dist_sc_feature(Feature1, Feature2)
Dist = sum((Feature1 - Feature2) .^ 2 ./ (Feature1 + Feature2 + 1e-8));
