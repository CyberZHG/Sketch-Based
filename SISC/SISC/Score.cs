using System;
using System.Collections.Generic;

namespace SISC
{
    class Score : IComparable<Score>
    {
        public int index;
        public double score;

        public int CompareTo(Score other)
        {
            if (Math.Abs(score - other.score) < 1e-6)
            {
                return index - other.index;
            }
            if (score < other.score)
            {
                return -1;
            }
            return 1;
        }
    }
}
