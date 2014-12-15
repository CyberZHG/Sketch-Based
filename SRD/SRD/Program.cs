using System;

namespace SRD
{
    class Program
    {
        static void Main(string[] args)
        {
            Worker worker = new Worker("PI100.task", 6);
            worker.work();
        }
    }
}
