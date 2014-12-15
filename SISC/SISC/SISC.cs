using System;
using System.Collections.Generic;
using System.IO;

namespace SISC
{
    class SISC
    {
        private const int binAngle = 12;
        private const int binNorm = 5;

        private List<double[,]> histogram = new List<double[,]>();

        public SISC()
        {
        }

        public void extract(String fileName)
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
                dmean = dmean / (points.Count + 0.1);
                double radius = dmean * 2.0;

                double[,] hist = new double[binAngle, binNorm];
                int totalNum = 0;
                double phi = Math.PI * 2.0 / binAngle;
                double len = radius / binNorm;
                for (int i = 0; i < points.Count; ++i)
                {
                    if (dists[i] < radius)
                    {
                        ++totalNum;
                        int indexAngle = (int)Math.Floor((points[i] - center).angle() / phi) % binAngle;
                        int indexNorm = (int)Math.Floor(dists[i] / len) % binNorm;
                        ++hist[indexAngle, indexNorm];
                    }
                }

                for (int i = 0; i < binAngle; ++i)
                {
                    for (int j = 0; j < binNorm; ++j)
                    {
                        hist[i, j] /= totalNum + 0.1;
                    }
                }
                histogram.Add(hist);

                points.Add(center);
            }
        }

        public void save(String fileName)
        {
            StreamWriter writer = new StreamWriter(fileName);
            writer.WriteLine(histogram.Count.ToString());
            for (int i = 0; i < histogram.Count; ++i)
            {
                for (int j = 0; j < binAngle; ++j)
                {
                    for (int k = 0; k < binNorm; ++k)
                    {
                        if (k > 0)
                        {
                            writer.Write(" ");
                        }
                        writer.Write(histogram[i][j, k].ToString("0.000000000"));
                    }
                    writer.WriteLine();
                }
            }
            writer.Close();
        }

        public void load(String fileName)
        {
            StreamReader reader = new StreamReader(fileName);
            int histNum = int.Parse(reader.ReadLine());
            for (int i = 0; i < histNum; ++i)
            {
                double[,] hist = new double[binAngle, binNorm];
                for (int j = 0; j < binAngle; ++j)
                {
                    string[] values = reader.ReadLine().Split(' ');
                    for (int k = 0; k < binNorm; ++k)
                    {
                        hist[j, k] = double.Parse(values[k]);
                    }
                }
                histogram.Add(hist);
            }
            reader.Close();
        }

        public static double dist(SISC a, SISC b)
        {
            double dist = 0.0;
            for (int i = 0; i < a.histogram.Count; ++i)
            {
                double d = 1e100;
                for (int j = 0; j < b.histogram.Count; ++j)
                {
                    double t = 0.0;
                    for (int ang = 0; ang < binAngle; ++ang)
                    {
                        for (int nor = 0; nor < binNorm; ++nor)
                        {
                            double g = a.histogram[i][ang, nor];
                            double h = b.histogram[j][ang, nor];
                            t += (g - h) * (g - h) / (g + h + 0.001);
                        }
                    }
                    d = Math.Min(d, t);
                }
                dist += d;
            }
            return dist;
        }
    }
}
