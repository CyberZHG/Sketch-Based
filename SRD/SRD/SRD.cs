using System;
using System.Collections.Generic;

namespace SRD
{
    class SRD
    {
        public double[,] histogram = new double[256, 256];

        public SRD(String fileName)
        {
            Sketch sketch = new Sketch(fileName);
            List<Point> points = sketch.points;

            for (int s = 0; s < points.Count; ++s)
            {
                Point center = points[0];
                points.RemoveAt(0);

                double dmean = 0.0;
                List<double> dists = new List<double>();
                for (int i = 0; i < points.Count; ++i)
                {
                    dists.Add((points[i] - center).norm());
                    dmean += dists[i];
                }
                dmean = dmean / (points.Count + 0.01);

                List<Point> nearPoints = new List<Point>();
                List<Point> farPoints = new List<Point>();
                for (int i = 0; i < points.Count; ++i)
                {
                    if (dists[i] < dmean)
                    {
                        nearPoints.Add(points[i]);
                    }
                    else
                    {
                        farPoints.Add(points[i]);
                    }
                }

                double phi = Math.PI * 2.0 / 8.0;
                double[] nearCount = new double[8];
                for (int i = 0; i < nearPoints.Count; ++i)
                {
                    int bin = (int)Math.Floor((nearPoints[i] - center).angle() / phi) % 8;
                    ++nearCount[bin];
                }
                double[] farCount = new double[8];
                for (int i = 0; i < farPoints.Count; ++i)
                {
                    int bin = (int)Math.Floor((farPoints[i] - center).angle() / phi) % 8;
                    ++farCount[bin];
                }
                for (int i = 0; i < 8; ++i)
                {
                    nearCount[i] = nearCount[i] / (nearPoints.Count + 0.01);
                    farCount[i] = farCount[i] / (farPoints.Count + 0.01);
                }

                int nearBin = 0;
                int farBin = 0;
                for (int i = 0; i < 8; ++i)
                {
                    if (nearCount[i] > 0.125)
                    {
                        nearBin |= 1 << i;
                    }
                    if (farCount[i] > 0.125)
                    {
                        farBin |= 1 << i;
                    }
                }
                ++histogram[nearBin, farBin];

                points.Add(center);
            }

            for (int i = 0; i < 256; ++i)
            {
                for (int j = 0; j < 256; ++j)
                {
                    histogram[i, j] = histogram[i, j] / (points.Count + 0.01);
                }
            }
        }

        public static double similarity(SRD a, SRD b)
        {
            double sim = 0.0;
            for (int i = 0; i < 256; ++i)
            {
                for (int j = 0; j < 256; ++j)
                {
                    sim += Math.Min(a.histogram[i, j], b.histogram[i, j]);
                }
            }
            return sim;
        }
    }
}
