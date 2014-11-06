#include "Task.h"
#include "Worker.h"

int main(int argc, char* argv[])
{
    Task task("task.txt");
    Worker worker;
    worker.work(task);
    return 0;
}
