#include <fstream>
#include "Task.h"

Task::Task(const char* taskFilePath)
{
    fstream fin;
    fin.open(taskFilePath, ios::in);
    int datasetImageNum = 0;
    fin >> datasetImageNum;
    string imageId;
    string sketchPath;
    for (int i = 0; i < datasetImageNum; ++i)
    {
        fin >> imageId >> sketchPath;
        _datasetImages[i] = { imageId, sketchPath };
    }
    int queryImageNum = 0;
    fin >> queryImageNum;
    string savePath;
    for (int i = 0; i < queryImageNum; ++i)
    {
        fin >> sketchPath >> savePath;
        _queryImages.push_back({ sketchPath, savePath });
    }
    fin.close();
}


Task::~Task()
{
}

void Task::run()
{

}