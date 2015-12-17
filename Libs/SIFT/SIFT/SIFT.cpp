#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <vector>
#include <string>
#include <iostream>
#include <algorithm>
#include <opencv2/opencv.hpp>
#include <opencv2/nonfree/nonfree.hpp>
#include "Task.h"
using namespace std;
using namespace cv;

struct Distance
{
    int index;
    double distance;

    bool operator< (const Distance& dist)
    {
        if (distance == dist.distance)
        {
            return index < dist.index;
        }
        return distance < dist.distance;
    }
};

int main()
{
    Task task;
    task.read("test.task");

    srand(time(nullptr));
    initModule_nonfree();

    vector<int> dictSizes = { 128, 256, 512, 1024 };
    vector<string> types = { "SIFT", "SURF" };

    for (auto type : types)
    {
        for (auto dictSize : dictSizes)
        {
            cout << "Type: " << type << " Size: " << dictSize << endl;
            BOWKMeansTrainer bow(dictSize);
            Ptr<FeatureDetector> detector = FeatureDetector::create(type.c_str());
            Ptr<DescriptorExtractor> extractor = DescriptorExtractor::create(type.c_str());
            Ptr<DescriptorMatcher> matcher = DescriptorMatcher::create("BruteForce");
            for (int i = 0; i < task.datasetNum; ++i)
            {
                cout << "Collecting... " << i + 1 << "\r";
                Mat image = imread(task.datasets[i].path.c_str(), CV_LOAD_IMAGE_GRAYSCALE);
                vector<KeyPoint> keyPoints;
                detector->detect(image, keyPoints);
                Mat descriptor;
                extractor->compute(image, keyPoints, descriptor);
                if (descriptor.rows)
                {
                    bow.add(descriptor);
                }
            }
            cout << endl;

            cout << "Generating Vocabulary" << endl;
            Mat vocabulary = bow.cluster();
            BOWImgDescriptorExtractor bowExtractor(extractor, matcher);
            bowExtractor.setVocabulary(vocabulary);

            vector<Mat> descriptors;
            vector<bool> valid;
            for (int i = 0; i < task.datasetNum; ++i)
            {
                cout << "Generating Feature... " << i + 1 << "\r";
                Mat image = imread(task.datasets[i].path.c_str(), CV_LOAD_IMAGE_GRAYSCALE);
                vector<KeyPoint> keyPoints;
                detector->detect(image, keyPoints);
                Mat descriptor;
                bowExtractor.compute(image, keyPoints, descriptor);
                if (descriptor.rows)
                {
                    valid.push_back(true);
                    normalize(descriptor, descriptor);
                }
                else
                {
                    valid.push_back(false);
                }
                descriptors.push_back(descriptor);
            }
            cout << endl;

            char resultPath[1024];
            sprintf(resultPath, "mkdir results_%s_%d", type.c_str(), dictSize);
            system(resultPath);
            for (int i = 0; i < task.queryNum; ++i)
            {
                cout << "Querying... " << i + 1 << "\r";
                Mat image = imread(task.queries[i].path.c_str(), CV_LOAD_IMAGE_GRAYSCALE);
                vector<KeyPoint> keyPoints;
                detector->detect(image, keyPoints);
                Mat descriptor;
                bowExtractor.compute(image, keyPoints, descriptor);
                vector<Distance> dists;
                if (descriptor.rows)
                {
                    normalize(descriptor, descriptor);
                    for (int j = 0; j < task.datasetNum; ++j)
                    {
                        if (valid[j])
                        {
                            double dist = norm(descriptor, descriptors[j], NORM_L2);
                            dists.push_back({ j, dist });
                        }
                        else
                        {
                            dists.push_back({ j, 1e100 });
                        }
                    }
                }
                else
                {
                    for (int j = 0; j < task.datasetNum; ++j)
                    {
                        double dist = (double)rand() / RAND_MAX;
                        dists.push_back({ j, dist });
                    }
                }
                sort(dists.begin(), dists.end());
                sprintf(resultPath, "results_%s_%d/%s.result", type.c_str(), dictSize, task.queries[i].name.c_str());
                FILE* file = fopen(resultPath, "w");
                for (int j = 0; j < dists.size(); ++j)
                {
                    fprintf(file, "%s\n", task.datasets[dists[j].index].name.c_str());
                }
                fclose(file);
            }
            cout << endl;
        }
    }

	return 0;
}

