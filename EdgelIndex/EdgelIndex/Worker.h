#pragma once

#include <Windows.h>
#include "Task.h"
#include "EdgelIndex.h"

class Worker
{
public:
    Worker();
    virtual ~Worker();

    void work(Task& task, int threadNum = 1);

private:
    Task* _task;
    EdgelIndex* _edgelIndex;
    int _shift;
    int _threadNum;
    HANDLE _shiftMutex;
    static DWORD WINAPI queryThreadEntry(LPVOID self);
    void queryThread();
};

