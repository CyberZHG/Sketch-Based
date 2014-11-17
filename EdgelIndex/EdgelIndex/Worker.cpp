#include <fstream>
#include <iostream>
#include "Worker.h"
using namespace std;

Worker::Worker()
{
}


Worker::~Worker()
{
}

void Worker::work(Task& task, int threadNum)
{
    _task = &task;
    _edgelIndex = new EdgelIndex();
    _edgelIndex->generateEdgelIndex(task.datasetImages(), threadNum);
    _shift = 0;
    _threadNum = threadNum;
    _shiftMutex = CreateMutex(NULL, FALSE, NULL);
    for (int i = 1; i < threadNum; ++i)
    {
        CreateThread(0, 0, queryThreadEntry, this, 0, 0);
    }
    queryThread();
    delete _edgelIndex;
}

DWORD WINAPI Worker::queryThreadEntry(LPVOID self)
{
    reinterpret_cast<Worker*>(self)->queryThread();
    return 0;
}

void Worker::queryThread()
{
    int len = _task->queryImages().size();
    WaitForSingleObject(_shiftMutex, INFINITE);
    int shift = _shift++;
    ReleaseMutex(_shiftMutex);
    for (int i = shift; i < len; i += _threadNum)
    {
        auto queryImage = _task->queryImages()[i];
        const string& queryPath = queryImage.sketchPath;
        const string& outputPath = queryImage.outputPath;
        cout << "Query: " << queryPath << endl;
        Sketch querySketch(queryPath.c_str());
        auto scores = _edgelIndex->query(_task->datasetImages(), querySketch);
        fstream fout;
        fout.open(outputPath.c_str(), ios::out);
        for (auto score : scores)
        {
            fout << _task->datasetImages()[score.id].id << ' ' << score.score << endl;
        }
        fout.close();
    }
}