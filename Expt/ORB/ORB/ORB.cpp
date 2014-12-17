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
    task.read("PI100.task");

    srand(time(nullptr));
    initModule_nonfree();

    vector<Mat> descriptors;
    OrbFeatureDetector detector(500, 1.2f, 8, 14, 0, 2, 0, 14);
    OrbDescriptorExtractor extractor(500, 1.2f, 8, 14, 0, 2, 0, 24);
    BFMatcher matcher(NORM_L1);
    for (int i = 0; i < task.datasetNum; ++i)
    {
        cout << "Collecting... " << i + 1 << "\r";
        Mat image = imread(task.datasets[i].path.c_str(), CV_LOAD_IMAGE_GRAYSCALE);
        vector<KeyPoint> keyPoints;
        detector.detect(image, keyPoints);
        Mat descriptor;
        extractor.compute(image, keyPoints, descriptor);
        descriptors.push_back(descriptor);
    }
    cout << endl;

    char resultPath[1024];
    system("mkdir results");
    for (int i = 0; i < task.queryNum; ++i)
    {
        cout << "Querying... " << i + 1 << "\r";
        Mat image = imread(task.queries[i].path.c_str(), CV_LOAD_IMAGE_GRAYSCALE);
        vector<KeyPoint> keyPoints;
        detector.detect(image, keyPoints);
        Mat descriptor;
        extractor.compute(image, keyPoints, descriptor);
        vector<Distance> dists;
        if (descriptor.rows == 0)
        {
            for (int j = 0; j < task.datasetNum; ++j)
            {
                dists.push_back({ j, (double)rand() / RAND_MAX });
            }
        }
        else
        {
            for (int j = 0; j < task.datasetNum; ++j)
            {
                vector<DMatch> matches;
                if (descriptors[j].rows == 0)
                {
                    dists.push_back({ j, 1e100 });
                }
                else
                {
                    matcher.match(descriptor, descriptors[j], matches);
                    double dist = 0.0;
                    for (int k = 0; k < matches.size(); ++k)
                    {
                        dist += matches[k].distance;
                    }
                    dists.push_back({ j, dist });
                }
            }
        }
        sort(dists.begin(), dists.end());
        sprintf(resultPath, "results/%s.result", task.queries[i].name.c_str());
        FILE* file = fopen(resultPath, "w");
        for (int j = 0; j < dists.size(); ++j)
        {
            fprintf(file, "%s\n", task.datasets[dists[j].index].name.c_str());
        }
        fclose(file);
    }
    cout << endl;

	return 0;
}

