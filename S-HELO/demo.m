sketch = imread('test.jpg');
if size(sketch, 3) > 1
    sketch = rgb2gray(sketch);
end
sketch = im2double(sketch);
feature = extract_shelo(sketch);