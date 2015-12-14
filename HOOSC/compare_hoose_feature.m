function Dist = compare_hoose_feature(Idx1, Idx2, K)
Feature1 = get_clustered_hoose_feature(Idx1, K);
Feature2 = get_clustered_hoose_feature(Idx2, K);
Dist = norm(Feature1 - Feature2, 1);
