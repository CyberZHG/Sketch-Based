using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;

namespace SISC
{
    class Worker
    {
        private const int INTERVAL = 2000;

        private Task task;
        private List<Score>[] scores;
        private SISC[] datasets = new SISC[INTERVAL];

        private int threadNum;
        private int shifts;
        private int progress;
        private int start;
        private int end;
        private Object lockObject = new Object();

        public Worker(String fileName, int threadNum = 1)
        {
            this.task = new Task(fileName);
            this.threadNum = threadNum;
            this.scores = new List<Score>[task.queryNames.Count];
            for (int i = 0; i < this.scores.Length; ++i)
            {
                this.scores[i] = new List<Score>();
            }
            for (int i = 0; i < INTERVAL; ++i)
            {
                this.datasets[i] = new SISC();
            }
        }

        public void extractThread()
        {
            int shift = 0;
            lock (lockObject)
            {
                shift = shifts++;
            }
            for (int k = start + shift; k < end; k += threadNum)
            {
                datasets[k - start].extract(task.datasetPaths[k]);
                ++progress;
                Console.Write("Progress: " + (100.0 * progress / INTERVAL).ToString("0.00") + "%\r");
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
                for (int i = 0; i < end - start; ++i)
                {
                    Score score = new Score();
                    score.index = start + i;
                    score.score = SISC.dist(query, datasets[i]);
                    scores[k].Add(score);
                }
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
            for (start = 0; start < task.datasetNames.Count; start += INTERVAL)
            {
                end = Math.Min(start + INTERVAL, task.datasetNames.Count);
                Console.WriteLine("Interval: [" + start.ToString() + ", " + end.ToString() + "]");

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
            if (!Directory.Exists("results"))
            {
                Directory.CreateDirectory("results");
            }
            for (int i = 0; i < task.queryNames.Count; ++i)
            {
                scores[i].Sort();
                StreamWriter writer = new StreamWriter("results/" + task.queryNames[i] + ".result");
                for (int j = 0; j < scores[i].Count; ++j)
                {
                    writer.WriteLine(task.datasetNames[scores[i][j].index]);
                }
                writer.Close();
            }
        }
    }
}
