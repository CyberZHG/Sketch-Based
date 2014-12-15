using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;

namespace SISC
{
    class Worker
    {
        private Task task;

        private int threadNum;
        private int shifts;
        private int progress;
        private Object lockObject = new Object();

        public Worker(String fileName, int threadNum = 1)
        {
            this.task = new Task(fileName);
            this.threadNum = threadNum;
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
                SISC dataset = new SISC();
                dataset.extract(task.datasetPaths[k]);
                dataset.save("features/" + task.datasetNames[k] + ".sisc");
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
                SISC query = new SISC();
                query.extract(task.queryPaths[k]);
                List<Score> scores = new List<Score>();
                for (int i = 0; i < task.datasetNames.Count; ++i)
                {
                    SISC dataset = new SISC();
                    dataset.load("features/" + task.datasetNames[i] + ".sisc");
                    Score score = new Score();
                    score.index = i;
                    score.score = SISC.dist(query, dataset);
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
            if (!Directory.Exists("features"))
            {
                Directory.CreateDirectory("features");
            }
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
