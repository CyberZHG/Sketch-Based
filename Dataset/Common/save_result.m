function save_result(Datasets, Queries, Results, Path)
    % Datasets: N x 1 cells containing the ids of dataset images.
    % Queries: M x 1 cells containing the ids of query images.
    % Results: N x M matrix, each column contains the ranking of the
    % dataset images.
    FD = fopen(Path, 'w');
    N = length(Datasets);
    M = length(Queries);
    for i = 1 : M
        fprintf(FD, '%s', Queries{i});
        for j = 1 : min([100 N])
            fprintf(FD, ' %s', Datasets{Results(j, i)});
        end
        fprintf(FD, '\n');
    end
    fclose(FD);
end