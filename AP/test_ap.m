function Results = test_ap(Datasets, Queries, AngleBinNum, NormBinNum)
    % Datasets: N x 1 cells containing location of dataset images.
    % Queries: M x 1 cells containing location of query images.
    % Results: N x M matrix, each column contains the ranking of the
    % dataset images.
    if nargin == 2
        AngleBinNum = 12;
        NormBinNum = 5;
    end
    N = length(Datasets);
    M = length(Queries);
    Features = zeros([AngleBinNum * NormBinNum, N]);
    parfor i = 1 : N
        Image = imread(Datasets{i});
        Image = im2double(Image);
        Features(:, i) = extract_ap(Image, AngleBinNum, NormBinNum);
    end
    Results = zeros([N, M]);
    for i = 1 : M
        Image = imread(Queries{i});
        Image = im2double(Image);
        Feature = extract_ap(Image, AngleBinNum, NormBinNum);
        Dist = zeros([N, 1]);
        parfor j = 1 : N
            Dist(j) = distance_ap(Feature, Features(:, j));
        end
        [~, Results(:, i)] = sort(Dist);
    end
end