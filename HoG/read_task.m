function Task = read_task(Path)
    File = fopen(Path, 'r');
    Task.Name = Path;
    Task.DatasetNum = fscanf(File, '%d', 1);
    Task.DatasetId = (1 : Task.DatasetNum)';
    Task.DatasetName = cell([Task.DatasetNum, 1]);
    Task.DatasetPath = cell([Task.DatasetNum, 1]);
    for i = 1 : Task.DatasetNum
        Task.DatasetName{i} = read_string(File);
        Task.DatasetPath{i} = read_string(File);
    end
    Task.QueryNum = fscanf(File, '%d', 1);
    Task.QueryName = cell([Task.QueryNum, 1]);
    Task.QueryPath = cell([Task.QueryNum, 1]);
    for i = 1 : Task.QueryNum
        Task.QueryName{i} = read_string(File);
        Task.QueryPath{i} = read_string(File);
    end
    fclose(File);
end