import os

# Dataset Description
# Line 1: N % Num of dataset images
# Line 2 ~ (N + 1): ID PATH
# Line N + 2: M % Num of test sketches
# Line (N + 3) ~ (N + 2 + M): ID PATH

def get_files_path(path):
    files_path = []
    for folder_name in os.listdir(path):
        folder_path = path + '/' + folder_name
        if os.path.isdir(folder_path):
            for file_name in os.listdir(folder_path):
                file_path = folder_path + '/' + file_name
                files_path.append(file_path)
    return files_path

def write_to_file(writer, files_path):
    writer.write(str(len(files_path)) + '\n')
    for i in range(len(files_path)):
        writer.write(str(i) + ' ' + files_path[i] + '\n')

imgs_path = []
with open('groundtruth') as reader:
    for line in reader.readlines():
        imgs_path.append('resize_img/' + line.strip().split(' ')[-1])

with open('Flickr15k.task', 'w') as writer:
    write_to_file(writer, imgs_path)
    write_to_file(writer, get_files_path('330sketches'))
