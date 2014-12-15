function Results = test_ap(Datasets, Queries, BinNum)
    % Datasets: N x 1 cells containing location of dataset images.
    % Queries: M x 1 cells containing location of query images.
    % Results: N x M matrix, each column contains the ranking of the
    % dataset images.
    if nargin == 2
        BinNum = 12;
    end
    N = length(Datasets);
    M = length(Queries);
    Features = zeros([BinNum, N]);
    parfor i = 1 : N
        Image = imread(Datasets{i});
        Image = im2double(Image);
        Features(:, i) = extract_ap(Image, BinNum);
    end
    Results = zeros([N, M]);
    for i = 1 : M
        Image = imread(Queries{i});
        Image = im2double(Image);
        Feature = extract_ap(Image, BinNum);
        Dist = zeros([N, 1]);
        parfor j = 1 : N
            Dist(j) = distance_ap(Feature, Features(:, j));
        end
        [~, Results(:, i)] = sort(Dist);
    end
end