#pragma once

#include <string>
using namespace std;

struct ImageInfo
{
    string id;
    string path;
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