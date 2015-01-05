using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BHoG
{
    class Program
    {
        static void Main(string[] args)
        {
            Worker worker = new Worker("test.task", 6);
            worker.work();
        }
    }
}
