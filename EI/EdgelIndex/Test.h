#pragma once

#include "Sketch.h"
#include "EdgelIndex.h"

class Test
{
public:
    Test();
    virtual ~Test();

    void saveHitmap(const Sketch& sketch, const char* fileName = "hitmap_%d.jpg");
};

