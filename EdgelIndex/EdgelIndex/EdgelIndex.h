#pragma once

#include <map>
#include "Sketch.h"
#include "ImageInfo.h"
using namespace std;

class EdgelIndex
{
public:
    EdgelIndex();
    virtual ~EdgelIndex();

    void generateEdgelIndex(map<int, DatasetImageInfo> &datasetImages);
    vector<Score> EdgelIndex::query(map<int, DatasetImageInfo> &images, const Sketch &querySketch);
    vector<vector<vector<bool>>> calcAngle(const Sketch &sketch);
    vector<vector<vector<bool>>> generateHitMap(const Sketch &sketch);
    void saveHitMap(const vector<vector<vector<bool>>>& hitmap, const char* fileName);
    vector<vector<vector<bool>>> readHitmap(const char* fileName);

private:
    vector<vector<vector<vector<int>>>> _edgelIndex;

    void localDfs(const Sketch &sketch, vector<vector<bool>> &local, const int x, const int y, const int lx, const int ly);
};

