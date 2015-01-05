using System;
using System.Collections.Generic;

namespace BHoG
{
    class Score : IComparable<Score>
    {
        public int index;
        public int score;

        public int CompareTo(Score other)
        {
            if (score == other.score)
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
