function String = read_line(File)
    Char = '';
    while ~feof(File)
        Char = fscanf(File, '%c', 1);
        Char = uint8(Char(1, 1));
        if Char == 10 || Char == 13
            continue;
        end
        break;
    end
    String = Char;
    while ~feof(File)
        Char = fscanf(File, '%c', 1);
        Char = uint8(Char(1, 1));
        if Char == 10 || Char == 13
            break;
        end
        String = [String char(Char)];
    end
end