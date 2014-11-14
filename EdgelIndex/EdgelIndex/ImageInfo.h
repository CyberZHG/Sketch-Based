#pragma once

#include <string>
using namespace std;

struct DatasetImageInfo
{
    string id;
    string sketchPath;
};

struct QueryImageInfo
{
    string sketchPath;
    string outputPath;
};

struct Score
{
    int id;
    double score;
    bool operator <(const Score &s) const
    {
        if (score == s.score)
        {
            return id < s.id;
        }
        return score > s.score;
    }
};