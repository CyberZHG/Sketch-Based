if exist('Flickr15k.mat', 'file')
    load('Flickr15k.mat', 'Task');
else
    Task = read_task('Flickr15k.task');
    save('Flickr15k.mat', 'Task');
end
if ~exist('crop_sketch', 'dir')
    mkdir('crop_sketch');
end
for i = 1 : length(Task.QueryPath)
    crop_sketch(Task.QueryPath{i}, Task.QueryPath{i}, [200 200]);
end
