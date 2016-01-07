if exist('filelist.mat', 'dir')
    load('filelist.mat', 'Dataset');
else
    Dataset = read_file_list('filelist.txt');
    save('filelist.mat', 'Dataset');
end

if ~exist('intermediate', 'dir')
    mkdir('intermediate');
end

if ~exist('intermediate/low_level', 'dir')
    mkdir('intermediate/low_level');
end

Fields = fieldnames(Dataset);
for i = 1 : numel(Fields)
    for j = 1 : length(Dataset.(Fields{i}))
        Value = Dataset.(Fields{i}){j};
        SavePath = ['intermediate/low_level/' strrep(Value, '/', '_') '.mat'];
        if ~exist(SavePath, 'file')
            ImagePath = ['sketches_png/png/' Value];
            Image = imread(ImagePath);
            Image = imresize(Image, [200, 200]);
            Feature = extract_d(Image);
            cheat_save(SavePath, Feature);
        end
    end
end

if ~exist('intermediate/low_level_merge', 'dir')
    mkdir('intermediate/low_level_merge');
end

for i = 1 : numel(Fields)
    if ~exist(['intermediate/low_level_merge/' Fields{i} '.mat'], 'file')
        Features = zeros(length(Dataset.(Fields{i})) * 784, 144);
        for j = 1 : length(Dataset.(Fields{i}))
            Value = Dataset.(Fields{i}){j};
            SavePath = ['intermediate/low_level/' strrep(Value, '/', '_') '.mat'];
            load(SavePath, 'Feature');
            Begin = (j - 1) * 784 + 1;
            End = j * 784;
            Features(Begin:End, :) = Feature;
        end
        SavePath = ['intermediate/low_level_merge/' Fields{i} '.mat'];
        save(SavePath, 'Features');
    end
end

if exist('intermediate/low_level_merge/low_level.mat', 'file')
    load('intermediate/low_level_merge/low_level.mat', 'Featuress');
else
    Featuress = zeros(20000 * 40, 144);
    for i = 1 : numel(Fields)
        SavePath = ['intermediate/low_level_merge/' Fields{i} '.mat'];
        load(SavePath, 'Features');
        Perm = randperm(80 * 784,  80 * 40);
        Begin = (i - 1) * 80 * 40 + 1;
        End = i * 80 * 40;
        Featuress(Begin:End, :) = Features(Perm, :);
    end
    save('intermediate/low_level_merge/low_level.mat', 'Featuress');
end

if ~exist('intermediate/mid_level', 'dir')
    mkdir('intermediate/mid_level');
end

visibleSize = 144;
hiddenSize = 160;
if exist('intermediate/mid_level/layer_1_param.mat', 'file')
    load('intermediate/mid_level/layer_1_param.mat', 'theta_layer_1', 'W1', 'b1', 'W2', 'b2');
else
    Perm = randperm(size(Featuress, 1), size(Featuress, 1) / 10);
    theta_layer_1 = sparse_auto_encoder(Featuress(Perm, :), visibleSize, hiddenSize);
    for i = 1 : 10
        Perm = randperm(size(Featuress, 1), size(Featuress, 1) / 10);
        theta_layer_1 = sparse_auto_encoder(Featuress(Perm, :), visibleSize, hiddenSize, theta_layer_1);
    end
    W1 = reshape(theta_layer_1(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
    b1 = theta_layer_1(2*hiddenSize*visibleSize+1:2*hiddenSize*visibleSize+hiddenSize);
    W2 = reshape(theta_layer_1(hiddenSize*visibleSize+1:2*hiddenSize*visibleSize), visibleSize, hiddenSize);
    b2 = theta_layer_1(2*hiddenSize*visibleSize+hiddenSize+1:end);
    save('intermediate/mid_level/layer_1_param.mat', 'theta_layer_1', 'W1', 'b1', 'W2', 'b2');
end

if exist('intermediate/mid_level/layer_1_data.mat', 'file')
    load('intermediate/mid_level/layer_1_data.mat', 'Featuress');
else
    [~, ~, Featuress] = getActivation(W1, W2, b1, b2, Featuress');
    Featuress = Featuress';
    save('intermediate/mid_level/layer_1_data.mat', 'Featuress');
end

if exist('intermediate/mid_level/layer_2_param.mat', 'file')
    load('intermediate/mid_level/layer_2_param.mat', 'theta_layer_2', 'W1', 'b1', 'W2', 'b2');
else
    Perm = randperm(size(Featuress, 1), size(Featuress, 1) / 10);
    theta_layer_2 = sparse_auto_encoder(Featuress(Perm, :), visibleSize, hiddenSize);
    for i = 1 : 10
        Perm = randperm(size(Featuress, 1), size(Featuress, 1) / 10);
        theta_layer_2 = sparse_auto_encoder(Featuress(Perm, :), visibleSize, hiddenSize, theta_layer_2);
    end
    W1 = reshape(theta_layer_2(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
    b1 = theta_layer_2(2*hiddenSize*visibleSize+1:2*hiddenSize*visibleSize+hiddenSize);
    W2 = reshape(theta_layer_2(hiddenSize*visibleSize+1:2*hiddenSize*visibleSize), visibleSize, hiddenSize);
    b2 = theta_layer_2(2*hiddenSize*visibleSize+hiddenSize+1:end);
    save('intermediate/mid_level/layer_2_param.mat', 'theta_layer_2', 'W1', 'b1', 'W2', 'b2');
end

if ~exist('intermediate/mid_level_layer_1', 'dir')
    mkdir('intermediate/mid_level_layer_1');
end

if ~exist('intermediate/mid_level_layer_2', 'dir')
    mkdir('intermediate/mid_level_layer_2');
end

if ~exist('intermediate/merge_level', 'dir')
    mkdir('intermediate/merge_level');
end

for i = 1 : numel(Fields)
    for j = 1 : length(Dataset.(Fields{i}))
        Value = Dataset.(Fields{i}){j};
        SavePath = ['intermediate/merge_level/' strrep(Value, '/', '_') '.mat'];
        if ~exist(SavePath, 'file')
            load(['intermediate/low_level/' strrep(Value, '/', '_') '.mat'], 'Feature');
            Features = zeros(size(Feature, 1), 144 + 160 + 160);
            Features(:, 1 : 144) = Feature;
            load('intermediate/mid_level/layer_1_param.mat', 'theta_layer_1', 'W1', 'b1', 'W2', 'b2');
            [~, Code, Output] = getActivation(W1, W2, b1, b2, Feature');
            Features(:, 145:304) = Code';
            save(['intermediate/mid_level_layer_1/' strrep(Value, '/', '_') '.mat'], 'Feature');
            load('intermediate/mid_level/layer_2_param.mat', 'theta_layer_2', 'W1', 'b1', 'W2', 'b2');
            [~, Code, ~] = getActivation(W1, W2, b1, b2, Output);
            Features(:, 305:end) = Code';
            save(['intermediate/mid_level_layer_2/' strrep(Value, '/', '_') '.mat'], 'Feature');
            Feature = Features;
            save(SavePath, 'Feature');
        end
    end
end

if ~exist('intermediate/merge_level_merge', 'dir')
    mkdir('intermediate/merge_level_merge');
end

for i = 1 : numel(Fields)
    if ~exist(['intermediate/merge_level_merge/' Fields{i} '.mat'], 'file')
        Features = zeros(length(Dataset.(Fields{i})) * 784, 144 + 160 + 160);
        for j = 1 : length(Dataset.(Fields{i}))
            Value = Dataset.(Fields{i}){j};
            SavePath = ['intermediate/merge_level/' strrep(Value, '/', '_') '.mat'];
            load(SavePath, 'Feature');
            Begin = (j - 1) * 784 + 1;
            End = j * 784;
            Features(Begin:End, :) = Feature;
        end
        SavePath = ['intermediate/merge_level_merge/' Fields{i} '.mat'];
        save(SavePath, 'Features');
    end
end

if exist('intermediate/merge_level_merge/merge.mat', 'file')
    load('intermediate/merge_level_merge/merge.mat', 'Featuress');
else
    Featuress = zeros(20000 * 5, 144 + 160 + 160);
    for i = 1 : numel(Fields)
        SavePath = ['intermediate/merge_level_merge/' Fields{i} '.mat'];
        load(SavePath, 'Features');
        Perm = randperm(80 * 784,  80 * 5);
        Begin = (i - 1) * 80 * 5 + 1;
        End = i * 80 * 5;
        Featuress(Begin:End, :) = Features(Perm, :);
    end
    save('intermediate/low_level_merge/merge.mat', 'Featuress');
end

if ~exist('intermediate/k-means', 'dir')
    mkdir('intermediate/k-means');
end

K = 256;

options = statset('UseParallel', 1);
if exist('intermediate/k-means/center_1.mat', 'file')
    load('intermediate/k-means/center_1.mat', 'Index1', 'Center1');
else
    [Index1, Center1] = kmeans(Featuress, K, 'Options', options, 'Display', 'iter', 'MaxIter', 300);
    save('intermediate/k-means/center_1.mat', 'Index1', 'Center1');
end

if exist('intermediate/k-means/residue.mat', 'file')
    load('intermediate/k-means/residue.mat', 'Featuress');
else
    for i = 1 : size(Featuress, 1)
        Featuress(i, :) = Featuress(i, :) - Center1(Index1(i), :);
    end
    save('intermediate/k-means/residue.mat', 'Featuress');
end

if exist('intermediate/k-means/center_2.mat', 'file')
    load('intermediate/k-means/center_2.mat', 'Center2');
else
    [~, Center2] = kmeans(Featuress, K, 'Options', options, 'Display', 'iter', 'MaxIter', 300);
    save('intermediate/k-means/center_2.mat', 'Center2');
end

if ~exist('intermediate/bow', 'dir')
    mkdir('intermediate/bow');
end

for i = 1 : numel(Fields)
    for j = 1 : length(Dataset.(Fields{i}))
        Value = Dataset.(Fields{i}){j};
        SavePath = ['intermediate/bow/' strrep(Value, '/', '_') '.mat'];
        if ~exist(SavePath, 'file')
            NextFeature = zeros([K + K, 1]);
            load(['intermediate/merge_level/' strrep(Value, '/', '_') '.mat'], 'Feature');
            for ii = 1 : size(Feature, 1)
                MinDist = 1e100;
                MinIndex = -1;
                for jj = 1 : K
                    Dist = norm(Feature(ii, :) - Center1(jj, :));
                    if Dist < MinDist
                        MinDist = Dist;
                        MinIndex = jj;
                    end
                end
                NextFeature(MinIndex) = NextFeature(MinIndex + 1) + 1;
                Residue = Feature(ii, :) - Center1(MinIndex, :);
                MinDist = 1e100;
                MinIndex = -1;
                for jj = 1 : K
                    Dist = norm(Feature(ii, :) - Center2(jj, :));
                    if Dist < MinDist
                        MinDist = Dist;
                        MinIndex = jj;
                    end
                end
                NextFeature(K + MinIndex) = NextFeature(K + MinIndex) + 1;
            end
            NextFeature(1:K) = NextFeature(1:K) / (norm(NextFeature(1:K)) + 1e-8);
            NextFeature(K+1:end) = NextFeature(K+1:end) / (norm(NextFeature(K+1:end)) + 1e-8);
            Feature = NextFeature;
            save(SavePath, 'Feature');
        end
    end
end

if exist('intermediate/bow/merge.mat', 'file')
    load('intermediate/bow/merge.mat', 'X', 'Y');
else
    Index = 0;
    X = zeros([20000, K + K]);
    Y = cell([20000, 1]);
    for i = 1 : numel(Fields)
        for j = 1 : length(Dataset.(Fields{i}))
            Value = Dataset.(Fields{i}){j};
            load(['intermediate/bow/' strrep(Value, '/', '_') '.mat'], 'Feature');
            Index = Index + 1;
            X(Index, :) = Feature;
            Y{Index} = Fields{i};
        end
    end
    save('intermediate/bow/merge.mat', 'X', 'Y');
end

if ~exist('intermediate/svm_model', 'dir')
    mkdir('intermediate/svm_model');
end

TrainX = zeros([14000, K + K]);
TrainY = cell([14000, 1]);

TestX = zeros([6000, K + K]);
TestY = cell([6000, 1]);

TrainIndex = 0;
TestIndex = 0;
for i = 1 : 20000
    if mod(i - 1, 80) < 56
        TrainIndex = TrainIndex + 1;
        TrainX(TrainIndex, :) = X(i, :);
        TrainY{TrainIndex} = Y{i};
    else
        TestIndex = TestIndex + 1;
        TestX(TestIndex, :) = X(i, :);
        TestY{TestIndex} = Y{i};
    end
end

for i = 1 : numel(Fields)
    SavePath = ['intermediate/svm_model/' Fields{i} '.mat'];
    if ~exist(SavePath, 'file')
        display([num2str(i) '/250 ' Fields{i}]);
        DY = zeros(14000, 1);
        for j = 1 : 14000
            if strcmp(TrainY{j}, Fields{i})
                DY(j) = 1;
            end
        end
        SVMModel = fitcsvm(TrainX, DY, 'ClassNames', [0 1]);
        save(SavePath, 'SVMModel');
    end
end

if ~exist('intermediate/svm_score', 'dir')
    mkdir('intermediate/svm_score');
end

Scores = zeros(6000, 1);
Scores = Scores - 1e100;
Results = zeros(6000, 1);
for i = 1 : numel(Fields)
    display([num2str(i) '/250 ' Fields{i}]);
    SavePath = ['intermediate/svm_score/' Fields{i} '.mat'];
    if exist(SavePath, 'file')
        load(SavePath, 'Label', 'Score');
    else
        load(['intermediate/svm_model/' Fields{i} '.mat'], 'SVMModel');
        [Label, Score] = predict(SVMModel, TestX);
        save(SavePath, 'Label', 'Score');
    end
    for j = 1 : 6000
        if Score(j, 2) > Scores(j)
            Scores(j) = Score(j, 2);
            Results(j) = i;
        end
    end
end

ClassifyResult = zeros(numel(Fields), numel(Fields));
for i = 1 : 6000
    RealClass = floor((i - 1) / 24) + 1;
    PredictClass = Results(i);
    ClassifyResult(RealClass, PredictClass) = ClassifyResult(RealClass, PredictClass) + 1;
end

ClassifyResult = ClassifyResult / 16;
imshow(ClassifyResult);

MeanResult = 0.0;
for i = 1 : numel(Fields)
    MeanResult = MeanResult + ClassifyResult(i, i);
end
MeanResult = MeanResult / numel(Fields);
