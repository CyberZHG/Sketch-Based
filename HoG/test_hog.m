function Results = test_hog(Datasets, Queries, Num, Bin)
    % Datasets: N x 1 cells containing the locations of dataset images.
    % Queries: M x 1 cells containing the locations of query images.
    % Results: N x M matrix, each column contains the ranking of the
    % dataset images.
    if nargin < 3
        Num = 5;
    end
    if nargin < 4
        Bin = 9;
    end
    N = length(Datasets);
    M = length(Queries);
    Features = zeros([Num * Num * Bin, N]);
    parfor i = 1 : N
        Image = imread(Datasets{i});
        Features(:, i) = extract_grid_hog(Image, Num, Bin);
    end
    Results = zeros([N, M]);
    for i = 1 : M
        Image = imread(Queries{i});
        Feature = extract_grid_hog(Image, Num, Bin);
        Dist = zeros([N, 1]);
        parfor j = 1 : N
            Dist(j) = norm(Feature - Features(:, j));
        end
        [~, Results(:, i)] = sort(Dist);
    end
end