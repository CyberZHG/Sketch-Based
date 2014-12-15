using System;
using System.Collections.Generic;
using System.Drawing;

namespace SRD
{
    class Sketch
    {
        public List<Point> points;

        public Sketch(String fileName)
        {
            points = new List<Point>();
            Bitmap bitmap = new Bitmap(fileName);
            for (int x = 0; x < bitmap.Width; ++x)
            {
                for (int y = 0; y < bitmap.Height; ++y)
                {
                    if (bitmap.GetPixel(x, y).GetBrightness() > 0.5f)
                    {
                        points.Add(new Point(x, y));
                    }
                }
            }
        }
    }
}
