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

    map<string, DatasetImageInfo>& datasetImages();
    vector<QueryImageInfo>& queryImages();

private:
    map<string, DatasetImageInfo> _datasetImages;
    vector<QueryImageInfo> _queryImages;
};

inline map<string, DatasetImageInfo>& Task::datasetImages()
{
    return _datasetImages;
}

inline vector<QueryImageInfo>& Task::queryImages()
{
    return _queryImages;
}