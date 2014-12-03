function Results = test_phog_g(Datasets, Queries, LayerNum, Bin)
    % Glboal feature test.
    % Datasets: N x 1 cells containing location of dataset images.
    % Queries: M x 1 cells containing location of query images.
    % Results: N x M matrix, each column contains the ranking of the
    % dataset images.
    if nargin < 3
        LayerNum = 3;
    end
    if nargin < 4
        Bin = 9;
    end
    N = length(Datasets);
    M = length(Queries);
    TotalNum = 0;
    Temp = 1;
    for i = 1 : LayerNum
        TotalNum = TotalNum + Temp;
        Temp = Temp * 4;
    end
    Features = zeros([TotalNum * Bin, N]);
    parfor i = 1 : N
        Image = imread(Datasets{i});
        Features(:, i) = extract_phog(Image, LayerNum, Bin);
    end
    Results = zeros([N, M]);
    for i = 1 : M
        Image = imread(Queries{i});
        Feature = extract_phog(Image, LayerNum, Bin);
        Dist = zeros([N, 1]);
        parfor j = 1 : N
            Dist(j) = norm(Feature - Features(:, j));
        end
        [~, Results(:, i)] = sort(Dist);
    end
end