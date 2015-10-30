import os
import shutil

if not os.path.exists('result/top10'):
    os.makedirs('result/top10')

with open('Flickr15k.task') as reader:
    n = int(reader.readline().strip())
    img_path = []
    for i in range(n):
        img_path.append(reader.readline().strip().split(' ')[-1])
    m = int(reader.readline().strip())
    test_path = []
    for i in range(m):
        test_path.append(reader.readline().strip().split(' ')[-1])

def get_category(path):
    cats = {}
    with open(path) as reader:
        for line in reader.readlines():
            nums = map(int, line.strip().split(' '))
            id = nums[0]
            cat = nums[1]
            cats[id] = cat
    return cats

src_cats = get_category('src_category')
test_cats = get_category('test_category')

with open('Flickr15k.result') as reader:
    for line in reader.readlines():
        nums = map(int, line.strip().split(' '))
        id = nums[0]
        cat = test_cats[id]
        ids = nums[1:]
        folder_path = 'result/top10/' + str(cat) + '/'
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
        shutil.copyfile(test_path[id], folder_path + str(id) + '_0.jpg')
        for i in range(1, 11):
            src_path = 'resize_img/' + ('/'.join(img_path[ids[i]].split('/')[1:]))
            shutil.copyfile(src_path, folder_path + str(id) + '_' + str(i) + '.png')
