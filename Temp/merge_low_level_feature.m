
Fields = fieldnames(Dataset);
parfor i = 1 : numel(Fields)
    for j = 1 : length(Dataset.(Fields{i}))
        Value = Dataset.(Fields{i}){j};
        SavePath = ['intermediate/low_level/' strrep(Value, '/', '_') '.mat'];
        if ~exist(SavePath, 'file')
            ImagePath = ['sketches_png/png/' Value];
            Image = imread(ImagePath);
            Image = imresize(Image, [200, 200]);
            imshow(Image);
            Feature = extract_d(Image);
            cheat_save(SavePath, 'Feature');
        end
    end
end