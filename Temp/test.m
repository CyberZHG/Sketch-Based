for i = 1 : numel(Fields)
    for j = 1 : length(Dataset.(Fields{i}))
    display(['Cluster ' num2str(i) '/' num2str(numel(Fields)) ' ' num2str(j) '/' num2str(length(Dataset.(Fields{i})))]);
        Value = Dataset.(Fields{i}){j};
        SavePath = ['intermediate/bow/' strrep(Value, '/', '_') '.mat'];
        %if ~exist(SavePath, 'file')
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
                    NextFeature(jj) = NextFeature(jj) + exp(-Dist);
                end
                Residue = Feature(ii, :) - Center1(MinIndex, :);
                for jj = 1 : K
                    Dist = norm(Feature(ii, :) - Center2(jj, :));
                    NextFeature(K + jj) = NextFeature(K + jj) + exp(-Dist);
                end
            end
            NextFeature(1:K) = NextFeature(1:K) / (norm(NextFeature(1:K)) + 1e-8);
            NextFeature(K+1:end) = NextFeature(K+1:end) / (norm(NextFeature(K+1:end)) + 1e-8);
            Feature = NextFeature;
            save(SavePath, 'Feature');
       % end
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
    %if ~exist(SavePath, 'file')
        display([num2str(i) '/250 ' Fields{i}]);
        DY = zeros(14000, 1);
        for j = 1 : 14000
            if strcmp(TrainY{j}, Fields{i})
                DY(j) = 1;
            end
        end
        SVMModel = fitcsvm(TrainX, DY, 'ClassNames', [0 1]);
        save(SavePath, 'SVMModel');
    %end
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
    %if exist(SavePath, 'file')
        %load(SavePath, 'Label', 'Score');
    %else
        load(['intermediate/svm_model/' Fields{i} '.mat'], 'SVMModel');
        [Label, Score] = predict(SVMModel, TestX);
        save(SavePath, 'Label', 'Score');
    %end
    for j = 1 : 6000
        if Score(j, 2) > Scores(j)
            Scores(j) = Score(j, 2);
            Results(j) = i;
        end
    end
end

if ~exist('intermediate/result', 'dir')
    mkdir('intermediate/result');
end

ClassifyResult = zeros(numel(Fields), numel(Fields));
for i = 1 : 6000
    RealClass = floor((i - 1) / 24) + 1;
    PredictClass = Results(i);
    ClassifyResult(RealClass, PredictClass) = ClassifyResult(RealClass, PredictClass) + 1;
    OriginPath = ['sketches_png/png/' Dataset.(Fields{RealClass}){mod(i - 1, 24) + 1}];
    if ~exist(['intermediate/result/' Fields{PredictClass}], 'dir')
        mkdir(['intermediate/result/' Fields{PredictClass}]);
    end
    TargetPath = ['intermediate/result/' Fields{PredictClass} '/' num2str(i) '.png'];
    copyfile(OriginPath, TargetPath);
end

ClassifyResult = ClassifyResult / 16;
imshow(ClassifyResult);

MeanResult = 0.0;
for i = 1 : numel(Fields)
    MeanResult = MeanResult + ClassifyResult(i, i);
end
MeanResult = MeanResult / numel(Fields);
save('intermediate/result/result.mat', 'Scores', 'Results', 'ClassifyResult', 'MeanResult');
