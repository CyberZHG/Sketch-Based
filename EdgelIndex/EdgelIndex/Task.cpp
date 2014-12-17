#include <fstream>
#include "Task.h"

Task::Task(const char* taskFilePath)
{
    fstream fin;
    fin.open(taskFilePath, ios::in);
    int datasetImageNum = 0;
    fin >> datasetImageNum;
    string id;
    string path;
    for (int i = 0; i < datasetImageNum; ++i)
    {
        fin >> id >> path;
        _datasetImages[i] = { id, path };
    }
    int queryImageNum = 0;
    fin >> queryImageNum;
    for (int i = 0; i < queryImageNum; ++i)
    {
        fin >> id >> path;
        _queryImages.push_back({ id, path });
    }
    fin.close();
}


Task::~Task()
{
}

void Task::run()
{

}