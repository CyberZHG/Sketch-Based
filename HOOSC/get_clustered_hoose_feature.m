function Feature = get_clustered_hoose_feature(Idx, K)
Feature = zeros([K, 1]);
for i = 1 : length(Idx)
    Feature(Idx(i)) = 1;
end
