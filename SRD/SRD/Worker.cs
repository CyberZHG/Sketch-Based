using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;

namespace SRD
{
    class Worker
    {
        private Task task;
        private SRD[] datasets;

        private int threadNum;
        private int shifts;
        private int progress;
        private Object lockObject = new Object();

        public Worker(String fileName, int threadNum = 1)
        {
            this.task = new Task(fileName);
            this.threadNum = threadNum;
            this.datasets = new SRD[task.datasetNames.Count];
        }

        public void extractThread()
        {
            int shift = 0;
            lock (lockObject)
            {
                shift = shifts++;
            }
            for (int k = shift; k < task.datasetNames.Count; k += threadNum)
            {
                datasets[k] = new SRD(task.datasetPaths[k]);
                ++progress;
                Console.Write("Progress: " + (100.0 * progress / task.datasetNames.Count).ToString("0.00") + "%\r");
            }
            lock (lockObject)
            {
                --shifts;
            }
        }

        public void queryThread()
        {
            int shift = 0;
            lock (lockObject)
            {
                shift = shifts++;
            }
            for (int k = shift; k < task.queryNames.Count; k += threadNum)
            {
                SRD query = new SRD(task.queryPaths[k]);
                List<Score> scores = new List<Score>();
                for (int i = 0; i < task.datasetNames.Count; ++i)
                {
                    Score score = new Score();
                    score.index = i;
                    score.score = SRD.similarity(query, datasets[i]);
                    scores.Add(score);
                }
                scores.Sort();
                StreamWriter writer = new StreamWriter("results/" + task.queryNames[k] + ".result");
                for (int i = 0; i < scores.Count; ++i)
                {
                    writer.WriteLine(task.datasetNames[scores[i].index]);
                }
                writer.Close();
                ++progress;
                Console.Write("Progress: " + (100.0 * progress / task.queryNames.Count).ToString("0.00") + "%\r");
            }
            lock (lockObject)
            {
                --shifts;
            }
        }

        public void work()
        {
            Console.WriteLine("Generating Dataset Features...");
            progress = 0;
            for (int i = 1; i < threadNum; ++i)
            {
                Thread thread = new Thread(new ThreadStart(extractThread));
                thread.IsBackground = true;
                thread.Start();
            }
            extractThread();
            while (shifts != 0)
            {
                Thread.Sleep(100);
            }
            Console.WriteLine();

            Console.WriteLine("Querying...");
            if (!Directory.Exists("results"))
            {
                Directory.CreateDirectory("results");
            }
            progress = 0;
            for (int i = 1; i < threadNum; ++i)
            {
                Thread thread = new Thread(new ThreadStart(queryThread));
                thread.IsBackground = true;
                thread.Start();
            }
            queryThread();
            while (shifts != 0)
            {
                Thread.Sleep(100);
            }
            Console.WriteLine();
        }
    }
}
