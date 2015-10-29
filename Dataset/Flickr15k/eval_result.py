import os

# Result Description
# Each Line: ID (ID * 100)

# Evaluation result/result_s_{ID}, result/result_c_{Category}, result/summary
# Each Line: MATCH MAP RECALL

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

cat_nums = {}
with open('num_category') as reader:
    for line in reader.readlines():
        nums = map(int, line.strip().split(' '))
        cat = nums[0]
        num = nums[1]
        cat_nums[cat] = num

def save_single_result(path, cat, matches):
    global cat_nums
    num = cat_nums[cat]
    with open(path, 'w') as writer:
        for i in range(len(matches)):
            writer.write(' '.join(map(str, [matches[i], 100.0 * matches[i] / (i + 1), 100.0 * matches[i] / num])) + '\n')

results = {}
if not os.path.exists('result'):
    os.mkdir('result')
with open('Flickr15k.result') as reader:
    for line in reader.readlines():
        nums = map(int, line.strip().split(' '))
        id = nums[0]
        cat = test_cats[id]
        ids = nums[1:]
        matches = []
        matched = 0
        for i in ids:
            if cat == src_cats[i]:
                matched += 1
            matches.append(matched)
        save_single_result('result/result_s_' + str(id), cat, matches)
        if cat not in results.keys():
            results[cat] = {}
        results[cat][id] = matches

total_num = 0
total_precision = [0.0 for _ in range(100)]
total_recall = [0.0 for _ in range(100)]

def save_precision_and_recall(path, precision, recall):
    with open(path, 'w') as writer:
        for i in range(len(precision)):
            writer.write(' '.join(map(str, [i + 1, 100.0 * precision[i], 100.0 * recall[i]])) + '\n')

for cat, cat_result in results.items():
    cat_num = cat_nums[cat]
    total_num += len(cat_result)
    cat_precision = [0.0 for _ in range(100)]
    cat_recall = [0.0 for _ in range(100)]
    for id, matches in cat_result.items():
        for i in range(len(matches)):
            precision = 1.0 * matches[i] / (i + 1)
            recall = 1.0 * matches[i] / cat_num
            cat_precision[i] += precision
            cat_recall[i] += recall
    cat_precision = map(lambda x: x / len(cat_result), cat_precision)
    cat_recall = map(lambda x: x / len(cat_result), cat_recall)
    save_precision_and_recall('result/result_c_' + str(cat), cat_precision, cat_recall)
    for i in range(100):
        total_precision[i] += cat_precision[i]
        total_recall[i] += cat_recall[i]

total_precision = map(lambda x: x / len(results), total_precision)
total_recall = map(lambda x: x / len(results), total_recall)
save_precision_and_recall('result/summary', total_precision, total_recall)
