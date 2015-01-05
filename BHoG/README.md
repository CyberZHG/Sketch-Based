Binary HoG (BHoG)
=================

## Introduction

BHoG is an efficient SBIR method which binary encodes the principal gradient orientation.

* Fu, H., Zhao, H., Kong, X., & Zhang, X. (2014). **BHoG: binary descriptor for sketch-based image retrieval**. Multimedia Systems, 1-10.

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