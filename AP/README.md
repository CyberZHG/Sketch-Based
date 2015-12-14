Angular-Partitioning
====================

This implementation is based on:

* Chalechale, A., Naghdy, G., & Mertins, A. (2005). **Sketch-based image matching using angular partitioning**. Systems, Man and Cybernetics, Part A: Systems and Humans, IEEE Transactions on, 35(1), 28-41.

However, the algorithm has a bad performance since it simply counts the number of sketch pixels and only divides angle into bins. The implementation divide the distance to center into different bins in the same time, which enhanced the retrieving results. 