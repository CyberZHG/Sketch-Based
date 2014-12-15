using System;
using System.Collections.Generic;
using System.IO;

namespace SISC
{
    class Task
    {
        public List<String> datasetNames = new List<String>();
        public List<String> datasetPaths = new List<String>();
        public List<String> queryNames = new List<String>();
        public List<String> queryPaths = new List<String>();

        public Task(String fileName)
        {
            StreamReader reader = new StreamReader(fileName);
            int datasetNum = int.Parse(reader.ReadLine());
            for (int i = 0; i < datasetNum; ++i)
            {
                string[] line = reader.ReadLine().Split(' ');
                datasetNames.Add(line[0]);
                datasetPaths.Add(line[1]);
            }
            int queryNum = int.Parse(reader.ReadLine());
            for (int i = 0; i < queryNum; ++i)
            {
                string[] line = reader.ReadLine().Split(' ');
                queryNames.Add(line[0]);
                queryPaths.Add(line[1]);
            }
            reader.Close();
        }
    }
}
