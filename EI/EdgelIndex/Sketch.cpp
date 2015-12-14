#include <opencv2/opencv.hpp>
#include "Sketch.h"
using namespace cv;

Sketch::Sketch() :
    _data(200, vector<bool>(200, false))
{
}

Sketch::Sketch(const char* fileName) :
    _data(200, vector<bool>(200, false))
{
    IplImage* image = cvLoadImage(fileName, CV_LOAD_IMAGE_GRAYSCALE);
    if (image->width != 200 || image->height != 200)
    {
        IplImage* resized = cvCreateImage(Size(200, 200), image->depth, 1);
        cvResize(image, resized);
        cvReleaseImage(&image);
        image = resized;
    }
    for (int y = 0; y < 200; ++y)
    {
        for (int x = 0; x < 200; ++x)
        {
            _data[y][x] = ((unsigned char)((image->imageData + y * image->widthStep)[x])) < 128;
        }
    }
    cvReleaseImage(&image);
}

Sketch::~Sketch()
{
}

vector<bool>& Sketch::operator[](int index)
{
    return _data[index];
}

const vector<bool>& Sketch::operator[](int index) const
{
    return _data[index];
}

int Sketch::countSketchPixel() const
{
    int num = 0;
    for (int x = 0; x < 200; ++x)
    {
        for (int y = 0; y < 200; ++y)
        {
            num += _data[x][y];
        }
    }
    return num;
}