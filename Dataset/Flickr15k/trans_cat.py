import os

# Trans Description
# Each Line: ID CATEGORY
# 
# 100598: bird -> airplane

with open('Flickr15k.task') as reader:
    def read_file_ids(reader):
        imgs = {}
        n = int(reader.readline().strip())
        for i in range(n):
            words = reader.readline().strip().split(' ')
            id = words[0]
            path = ('/'.join(words[1].split('/')[1:])).split('.')[0]
            imgs[path] = id
        return imgs
    src_imgs = read_file_ids(reader)
    test_imgs = read_file_ids(reader)

cat_nums = {}
with open('src_category', 'w') as writer:
    with open('groundtruth') as reader:
        for line in reader.readlines():
            words = line.strip().split(' ')
            cat = words[0]
            if cat not in cat_nums.keys():
                cat_nums[cat] = 0
            cat_nums[cat] += 1
            path = words[1].split('.')[0]
            id = src_imgs[path]
            writer.write(id + ' ' + cat + '\n')

with open('num_category', 'w') as writer:
    for cat, num in cat_nums.items():
        writer.write(str(cat) + ' ' + str(num) + '\n')

with open('test_category', 'w') as writer:
    for path, id in test_imgs.items():
        cat = path.split('/')[-1].split('.')[0]
        writer.write(id + ' ' + cat + '\n')
