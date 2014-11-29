S-HELO
======

The paper was proposed in ICIP 2014, the author extracts the HELO (Histogram of Edge Local Orientation) feature using a soft manner, thus the method is called S-HELO.

* SKETCH BASED IMAGE RETRIEVAL USING A SOFT COMPUTATION OF THE HISTOGRAM OF EDGE LOCAL ORIENTATIONS (S-HELO)

# Demo

Usage:

```matlab
feature = extract_shelo(I, W, B, K);
```

* __I__ is the input image.
* __K__ is the number of bins of gradient orientation.
* __B__ is number of blocks in the image.
* __W__ is number of cells in the block.

The default value is W = 25, B = 6 and K = 36, which is described in table 2 of the paper. The extracted feature is normalized.

Demo:

```matlab
sketch = imread('test.jpg');
if size(sketch, 3) > 1
    sketch = rgb2gray(sketch);
end
sketch = im2double(sketch);
feature = extract_shelo(sketch);
```