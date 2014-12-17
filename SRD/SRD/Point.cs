using System;

namespace SRD
{
    class Point
    {
        public int x { get; set; }
        public int y { get; set; }

        public Point(int x = 0, int y = 0)
        {
            this.x = x;
            this.y = y;
        }

        public static Point operator -(Point a, Point b)
        {
            return new Point(a.x - b.x, a.y - b.y);
        }

        public double norm()
        {
            return Math.Sqrt(x * x + y * y);
        }

        public double angle()
        {
            double ang = Math.Atan2(y, x);
            if (ang < 0)
            {
                ang += Math.PI * 2.0;
            }
            return ang;
        }
    }
}
