using System;
using System.Collections.Generic;
using System.Drawing;

namespace BHoG
{
    class Sketch
    {
        public float[,] sketch;
        public double[,] amplitude;
        public int[,] angle;
        public int width, height;

        public Sketch(String fileName)
        {
            Bitmap bitmap = new Bitmap(fileName);
            width = bitmap.Width;
            height = bitmap.Height;
            sketch = new float[width, height];
            for (int x = 0; x < width; ++x)
            {
                for (int y = 0; y < height; ++y)
                {
                    sketch[x, y] = bitmap.GetPixel(x, y).GetBrightness();
                }
            }
        }

        public float safeGet(int x, int y)
        {
            if (0 <= x && x < width)
            {
                if (0 <= y && y < height)
                {
                    return sketch[x, y];
                }
            }
            return 0.0f;
        }

        public void calcGradient()
        {
            amplitude = new double[width, height];
            angle = new int[width, height];
            for (int i = 0; i < width; ++i)
            {
                for (int j = 0; j < height; ++j)
                {
                    float gx = safeGet(i - 1, j + 1) + 2 * safeGet(i, j + 1) + safeGet(i + 1, j + 1) -
                               safeGet(i - 1, j - 1) - 2 * safeGet(i, j - 1) - safeGet(i + 1, j - 1);
                    float gy = safeGet(i + 1, j - 1) + 2 * safeGet(i + 1, j) + safeGet(i + 1, j + 1) -
                               safeGet(i - 1, j - 1) - 2 * safeGet(i - 1, j) - safeGet(i - 1, j + 1);
                    amplitude[i, j] = Math.Sqrt(gx * gx + gy * gy);
                    angle[i, j] = (int)Math.Floor((Math.Atan2(gy, gx) + Math.PI * 8.0) / (Math.PI / 8.0)) % 8;
                }
            }
        }
    }
}
