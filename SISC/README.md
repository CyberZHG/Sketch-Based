Scale-Invariant Shape Context (SISC)
====================================

## Introduction

**SRD** and **SISC** are two kinds of descriptor proposed in:

* Chatbri, H., Kameyama, K., & Kwan, P. (2013, November). **Sketch-based image retrieval by size-adaptive and noise-robust feature description**. In Digital Image Computing: Techniques and Applications (DICTA), 2013 International Conference on (pp. 1-8). IEEE.

Note that **SISC** is _extremely_ slow.

## Task File Formatting

Task file is the input of the retrieval program. The format looks like:

```
DatasetImageNumber
ImageNames1 ImagePath1
ImageNames2 ImagePath2
ImageNames3 ImagePath3
...
QueryImageNumber
ImageNames4 ImagePath4
ImageNames5 ImagePath5
ImageNames6 ImagePath6
...
```

An example:

```
3
data1 data1.jpg
data2 data2.jpg
data3 data3.jpg
1
query query.jpg
```

The outputs will be placed in `results/<QueryName>.result`, each file contains a list of dataset image names sorted by similarities.