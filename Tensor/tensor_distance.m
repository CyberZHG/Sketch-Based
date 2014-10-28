function dist = tensor_distance(desc1, desc2)
% TENSOR_DISTANCE Calculate the distance of two tensor descriptors.
%
%    DIST = TENSOR_DISTANCE(DESC1, DESC2) calculate the distance using
%    Frobenius norm.
if size(desc1) ~= size(desc2)
    error('The size of the two descriptor is not the same.');
end
if size(desc1, 2) == 1
    index = 1;
    dist = 0.0;
    while index <= length(desc1)
        dist = dist + norm(desc1(index : index + 3) - desc2(index : index + 3), 'fro');
        index = index + 4;
    end
else
    dist = norm(desc1 - desc2, 'fro');
end
