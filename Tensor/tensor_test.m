function Results = tensor(Datasets, Queries, Num)
    % Datasets: N x 1 cells containing location of dataset images.
    % Queries: M x 1 cells containing location of query images.
    % Results: N x M matrix, each column contains the ranking of the
    % dataset images.
    if nargin < 3
        Num = 20;
    end
    N = length(Datasets);
    M = length(Queries);
    Features = zeros([Num * Num * 4, N]);
    parfor i = 1 : N
        Image = imread(Datasets{i});
        Features(:, i) = tensor_extract(Image, Num);
    end
    Results = zeros([N, M]);
    for i = 1 : M
        Image = imread(Queries{i});
        Feature = tensor_extract(Image, Num);
        Dist = zeros([N, 1]);
        parfor j = 1 : N
            Dist(j) = tensor_distance(Feature, Features(:, j));
        end
        [~, Results(:, i)] = sort(Dist);
    end
end