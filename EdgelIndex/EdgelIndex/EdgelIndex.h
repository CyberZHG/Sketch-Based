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

    void generateEdgelIndex(map<string, DatasetImageInfo> &datasetImages);
    vector<Score> EdgelIndex::query(map<string, DatasetImageInfo> &images, const Sketch &querySketch);
    vector<vector<vector<bool>>> calcAngle(const Sketch &sketch);
    vector<vector<vector<bool>>> generateHitMap(const Sketch &sketch);

private:
    vector<vector<vector<vector<string>>>> _edgelIndex;

    void localDfs(const Sketch &sketch, vector<vector<bool>> &local, const int x, const int y, const int lx, const int ly);
};

