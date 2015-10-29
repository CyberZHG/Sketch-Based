function String = read_string(File)
    Char = '';
    while ~feof(File)
        Char = fscanf(File, '%c', 1);
        Char = uint8(Char(1, 1));
        if Char == 32 || Char == 10 || Char == 13 || Char == 9
            continue;
        end
        break;
    end
    String = Char;
    while ~feof(File)
        Char = fscanf(File, '%c', 1);
        Char = uint8(Char(1, 1));
        if Char == 32 || Char == 10 || Char == 13 || Char == 9
            break;
        end
        String = strcat(String, char(Char));
    end
end