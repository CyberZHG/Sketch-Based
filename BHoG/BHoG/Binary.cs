using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BHoG
{
    class Binary
    {
        private int[] dist = new int[256];

        public Binary()
        {
            for (int i = 0; i < 256; ++i)
            {
                int j = i;
                while (j > 0)
                {
                    j = j & (j - 1);
                    ++dist[i];
                }
            }
        }

        public int compare(byte[] a, byte[] b)
        {
            int sum = 0;
            for (int i = 0; i < a.Length; ++i)
            {
                sum += dist[a[i] ^ b[i]];
            }
            return sum;
        }
    }
}
