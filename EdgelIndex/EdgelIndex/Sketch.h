#pragma once

#include <vector>
using namespace std;

/**
* Sketch should be a 200 * 200 grayscale image, in which sketch is represented by black pixels.
*/
class Sketch
{
public:
    Sketch();
    Sketch(const char* fileName);
    virtual ~Sketch();

    int countSketchPixel() const;

    vector<bool>& operator[](int index);
    const vector<bool>& operator[](int index) const;

private:
    vector<vector<bool>> _data;
};

