#include <fstream>
#include "Task.h"

Task::Task(const char* taskFilePath)
{
    fstream fin;
    fin.open(taskFilePath, ios::in);
    int datasetImageNum = 0;
    fin >> datasetImageNum;
    int id;
    string sketchPath, assistPath;
    for (int i = 0; i < datasetImageNum; ++i)
    {
        fin >> id >> sketchPath >> assistPath;
        _datasetImages[id] = { sketchPath, assistPath };
    }
    int queryImageNum = 0;
    fin >> queryImageNum;
    for (int i = 0; i < queryImageNum; ++i)
    {
        fin >> sketchPath >> assistPath;
        _queryImages.push_back({ sketchPath, assistPath });
    }
    fin.close();
}


Task::~Task()
{
}

void Task::run()
{

}