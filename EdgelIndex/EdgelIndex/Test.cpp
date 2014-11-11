#include <cstdio>
#include <opencv2/opencv.hpp>
#include "Test.h"
using namespace cv;

Test::Test()
{
}

Test::~Test()
{
}

void Test::saveHitmap(const Sketch& sketch, const char* fileName)
{
    EdgelIndex edgleIndex;
    auto hitmap = edgleIndex.generateHitMap(sketch);
    char finalName[128];
    for (int k = 0; k < 6; ++k)
    {
        sprintf(finalName, fileName, k);
        IplImage* image = cvCreateImage(Size(200, 200), 8, 1);
        for (int i = 0; i < 200; ++i)
        {
            for (int j = 0; j < 200; ++j)
            {
                image->imageData[i * 200 + j] = hitmap[i][j][k] ? 0 : 255;
            }
        }
        cvSaveImage(finalName, image);
        cvReleaseImage(&image);
    }
}