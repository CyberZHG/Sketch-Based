Edgel Index
===========

## Introduction

This is an implementation of:

* Cao, Y., Wang, C., Zhang, L., & Zhang, L. (2011, June). **Edgel index for large-scale sketch-based image search**. In Computer Vision and Pattern Recognition (CVPR), 2011 IEEE Conference on (pp. 761-768). IEEE.

without structure-consistent. The algorithm is used for sketch based image retrieval.

## Hit Map

Angle is divided into 6 bins, one hit map is generated in each bin.

The sketch:

![Sketch](https://cloud.githubusercontent.com/assets/853842/4989219/042843cc-69b0-11e4-8abb-126e75b80038.jpg)

The hit maps:

![hitmap_0](https://cloud.githubusercontent.com/assets/853842/4989213/03c20ca6-69b0-11e4-8f70-e25d36eafd29.jpg)
![hitmap_1](https://cloud.githubusercontent.com/assets/853842/4989214/03f6c360-69b0-11e4-8a63-810826c72511.jpg)
![hitmap_2](https://cloud.githubusercontent.com/assets/853842/4989215/03f9db0e-69b0-11e4-9cbe-8a396318123f.jpg)
![hitmap_3](https://cloud.githubusercontent.com/assets/853842/4989216/0418d306-69b0-11e4-8bec-3a00b6cdb727.jpg)
![hitmap_4](https://cloud.githubusercontent.com/assets/853842/4989218/04226e02-69b0-11e4-8845-8aa0a9db3b51.jpg)
![hitmap_5](https://cloud.githubusercontent.com/assets/853842/4989217/042026e2-69b0-11e4-9508-1e5d14a91c2a.jpg)

## Example

Assume that there are 40 natural images in the dataset, and we have one query sketch:

![Query Sketch](https://cloud.githubusercontent.com/assets/853842/4871361/000c4b6a-61b0-11e4-875b-1f90f7246d12.jpg)

The ranking of the dataset images is:

![Result](https://cloud.githubusercontent.com/assets/853842/4871453/0514bf3c-61b7-11e4-8ffc-57a9405658f1.jpg)