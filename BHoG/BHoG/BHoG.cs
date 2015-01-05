using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BHoG
{
    class BHoG
    {
        private const int BLOCK_NUM = 20;
        public byte[] code = new byte[BLOCK_NUM * BLOCK_NUM];

        public BHoG(String fileName)
        {
            byte[] encode = new byte[8];
            encode[0] = Convert.ToByte("11110000", 2);
            encode[1] = Convert.ToByte("01111000", 2);
            encode[2] = Convert.ToByte("00111100", 2);
            encode[3] = Convert.ToByte("00011110", 2);
            encode[4] = Convert.ToByte("00001111", 2);
            encode[5] = Convert.ToByte("10000111", 2);
            encode[6] = Convert.ToByte("11000011", 2);
            encode[7] = Convert.ToByte("11100001", 2);
            Sketch sketch = new Sketch(fileName);
            sketch.calcGradient();
            int width = sketch.width;
            int height = sketch.height;
            for (int i = 0; i < BLOCK_NUM; ++i)
            {
                for (int j = 0; j < BLOCK_NUM; ++j)
                {
                    int left = i * width / (BLOCK_NUM + 1);
                    int right = (i + 2) * width / (BLOCK_NUM + 1);
                    int top = j * height / (BLOCK_NUM + 1);
                    int bottom = (j + 2) * height / (BLOCK_NUM + 1);
                    double[] gradients = new double[8];
                    for (int x = left; x < right; ++x)
                    {
                        for (int y = top; y < bottom; ++y)
                        {
                            gradients[sketch.angle[x, y]] += sketch.amplitude[x, y];
                        }
                    }
                    int maxIndex = 0;
                    double total = gradients[0];
                    for (int k = 1; k < 8; ++k)
                    {
                        if (gradients[k] > gradients[maxIndex])
                        {
                            maxIndex = k;
                        }
                        total += gradients[k];
                    }
                    if (gradients[maxIndex] < 1e-3)
                    {
                        continue;
                    }
                    if (gradients[maxIndex] * 4.5 < total)
                    {
                        continue;
                    }
                    code[i * BLOCK_NUM + j] = encode[maxIndex];
                }
            }
        }
    }
}
