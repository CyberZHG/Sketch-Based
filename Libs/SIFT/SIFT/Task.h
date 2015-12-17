#pragma once

#include <vector>
#include <string>
using namespace std;

struct ImageInfo
{
    string name;
    string path;
};

struct Task
{
public:
    Task();
    ~Task();

    void read(const char* filePath);

    int datasetNum;
    int queryNum;
    vector<ImageInfo> datasets;
    vector<ImageInfo> queries;
};

