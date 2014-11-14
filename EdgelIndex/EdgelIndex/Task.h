#pragma once

#include <map>
#include <vector>
#include <string>
#include "ImageInfo.h"
using namespace std;

class Task
{
public:
    Task(const char* taskFilePath);
    virtual ~Task();

    void run();

    map<int, DatasetImageInfo>& datasetImages();
    vector<QueryImageInfo>& queryImages();

private:
    map<int, DatasetImageInfo> _datasetImages;
    vector<QueryImageInfo> _queryImages;
};

inline map<int, DatasetImageInfo>& Task::datasetImages()
{
    return _datasetImages;
}

inline vector<QueryImageInfo>& Task::queryImages()
{
    return _queryImages;
}