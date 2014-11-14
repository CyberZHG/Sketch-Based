#include <fstream>
#include <iostream>
#include "Worker.h"

Worker::Worker()
{
}


Worker::~Worker()
{
}

void Worker::work(Task& task)
{
    EdgelIndex edgelIndex;
    edgelIndex.generateEdgelIndex(task.datasetImages());
    for (auto queryImage : task.queryImages())
    {
        const string& queryPath = queryImage.sketchPath;
        const string& outputPath = queryImage.outputPath;
        cout << "Query: " << queryPath << endl;
        Sketch querySketch(queryPath.c_str());
        auto scores = edgelIndex.query(task.datasetImages(), querySketch);
        fstream fout;
        fout.open(outputPath.c_str(), ios::out);
        for (auto score : scores)
        {
            fout << task.datasetImages()[score.id].id << ' ' << score.score << endl;
        }
        fout.close();
    }
}