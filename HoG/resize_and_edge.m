if ~exist('resize_edge', 'dir')
    mkdir('resize_edge');
end
folders = dir('source');
for i = 1 : length(folders)
    if folders(i).isdir && folders(i).name(1) ~= '.'
        folder_name = folders(i).name;
        folder_path = ['source/' folder_name];
        target_folder_path = ['resize_edge/' folder_name];
        if ~exist(target_folder_path, 'dir')
            mkdir(target_folder_path);
        end
        files = dir(folder_path);
        parfor j = 1 : length(files)
            if files(j).name(1) ~= '.'
                file_name = files(j).name;
                file_path = [folder_path '/' file_name];
                target_path = [target_folder_path '/' file_name(1 : (length(file_name) - 3)) 'png'];
                im = imread(file_path);
                if size(im, 3) == 3
                    im = rgb2gray(im);
                end
                im = imresize(im, [200 200], 'bicubic');
                filter = fspecial('gaussian', [9 9], 4.0);
                im = imfilter(im, filter);
                im = edge(im, 'canny');
                im = 1 - im;
                imwrite(im, target_path);
            end
        end
    end
end