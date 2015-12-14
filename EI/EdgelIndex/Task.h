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

    map<int, ImageInfo>& datasetImages();
    vector<ImageInfo>& queryImages();

private:
    map<int, ImageInfo> _datasetImages;
    vector<ImageInfo> _queryImages;
};

inline map<int, ImageInfo>& Task::datasetImages()
{
    return _datasetImages;
}

inline vector<ImageInfo>& Task::queryImages()
{
    return _queryImages;
}