Tensor Descriptor
=================

## Introduction

This is the extraction of gradient tensor descriptor based on:

* Eitz, M., Hildebrand, K., Boubekeur, T., & Alexa, M. (2009, August). **A descriptor for large scale image retrieval based on sketched feature lines**. In SBM (pp. 29-36).

Example:
![Result](https://cloud.githubusercontent.com/assets/853842/4804025/2ab3e7f6-5e63-11e4-941e-655fcd5baaa8.jpg)

## Demo

```matlab
I = imread('test.jpg');
desc = tensor_extract(I, [16, 20]);
vis = tensor_visualization(I, [16, 20]);
imwrite(vis, 'result.jpg');
imshow(vis);
```