using System;

namespace SISC
{
    class Program
    {
        static void Main(string[] args)
        {
            Worker worker = new Worker("PI100.task", 8);
            worker.work();
        }
    }
}
