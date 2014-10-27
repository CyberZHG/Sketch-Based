Adaptive Thinning
=================

This is the implementation of an adaptive thinning algorithm based on:

* Chatbri, H., & Kameyama, K. (2012, November). **Towards making thinning algorithms robust against noise in sketch images**. In Pattern Recognition (ICPR), 2012 21st International Conference on (pp. 3030-3033). IEEE.
* Huang, L., Wan, G., & Liu, C. (2003, August). **An improved parallel thinning algorithm**. In 2013 12th International Conference on Document Analysis and Recognition (Vol. 2, pp. 780-780). IEEE Computer Society.

The algorithm takes a sketch image as input, produces thinned version of the sketch. The sketch is a one-pixel-wide skeleton which is visually similar to the original image, and preserves connectivity between foreground pixels.

Example:
![Input Sketch](https://cloud.githubusercontent.com/assets/853842/4787415/a62c71b4-5daa-11e4-89ee-de617aede8b7.jpg)
![Thinned](https://cloud.githubusercontent.com/assets/853842/4787414/a618a292-5daa-11e4-8c53-d656a3521565.jpg)
