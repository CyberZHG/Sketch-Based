function Dataset = read_file_list(FilePath)
    Dataset = struct;
    File = fopen(FilePath, 'r');
    while 1 == 1
        try
            Line = read_line(File);
        catch
            break
        end
        if length(Line) > 2
            Strs = regexp(Line, '/', 'split');
            Category = Strs{1};
            Category = strrep(Category, '(', '_');
            Category = strrep(Category, ')', '_');
            Category = strrep(Category, ' ', '_');
            Category = strrep(Category, '-', '_');
            if ~isfield(Dataset, Category)
                Dataset.(Category) = cell(0);
            end
            Dataset.(Category){end + 1} = Line;
        end
    end
end