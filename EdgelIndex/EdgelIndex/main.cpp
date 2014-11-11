#include <cstdio>
#include "Task.h"
#include "Worker.h"

const int TASK_ID[] = { 0, 1, 2, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 20, 21, 23, 24, 25, 26, 27, 28, 30, 33, 34, 38, 42, 43, 45, 46, 47, 48 };

int main(int argc, char* argv[])
{
    char name[128];
    for (int i = 0; i < 31; ++i)
    {
        sprintf_s(name, "task_%d.txt", TASK_ID[i]);
        printf("%s\n", name);
        Task task(name);
        Worker worker;
        worker.work(task);
    }
    return 0;
}
