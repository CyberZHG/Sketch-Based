#include <fstream>
#include "Task.h"

Task::Task()
{
}

Task::~Task()
{
}

void Task::read(const char* filePath)
{
    ifstream fin;
    fin.open(filePath, ios::in);
    fin >> datasetNum;
    datasets = vector<ImageInfo>(datasetNum);
    for (int i = 0; i < datasetNum; ++i)
    {
        fin >> datasets[i].name >> datasets[i].path;
    }
    fin >> queryNum;
    queries = vector<ImageInfo>(queryNum);
    for (int i = 0; i < queryNum; ++i)
    {
        fin >> queries[i].name >> queries[i].path;
    }
}