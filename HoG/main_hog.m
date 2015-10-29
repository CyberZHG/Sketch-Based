if exist('Flickr15k.mat', 'file')
    load('Flickr15k.mat', 'Task');
else
    Task = read_task('Flickr15k.task');
    save('Flickr15k.mat', 'Task');
end
Result = test_hog(Task.DatasetPath, Task.QueryPath);
save_result(Task.DatasetName, Task.QueryName, Result, 'Flickr15k.result');
