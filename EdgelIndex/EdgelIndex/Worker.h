#pragma once

#include "Task.h"
#include "EdgelIndex.h"

class Worker
{
public:
    Worker();
    virtual ~Worker();

    void work(Task& task);
};

