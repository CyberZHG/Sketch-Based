function map = generate_hit_map(sketch)
    % GENERATE_HIT_MAP Generate hit maps in different orientations.
    %
    %   MAP = GENERATE_HIT_MAP(SKETCH) The input is a sketch image with
    %   arbitrary size. The sketch will be resized to 200 * 200, and the hit
    %   maps of 6 orientations will be generated. The function returns 200 *
    %   200 * 6 matrix representing the hit maps.
    TOLERANCE_RADIUS = 4;
    NEIGHBOR = [-1, 0; 1, 0; 0, -1; 0, 1];
    % Initialize angle bin.
    sketch = imresize(sketch, [200 200]);
    sketch = sketch > (max(max(sketch)) * 0.5);
    [dx, dy] = gradient(double(sketch));
    theta = atan2(dy, dx) / pi * 360;
    theta = theta + (theta < -15) * 180;
    theta = floor((theta + 15) / 30) + 1;
    % Breadth first search.
    map = zeros(200, 200, 6);
    queue = zeros(200 * 200 * 6, 3);
    front = 1;
    rear = 1;
    for i = 1 : 200
        for j = 1 : 200
            map(i, j, theta(i, j)) = 1;
            queue(rear, :) = [i, j, theta(i, j)];
            rear = rear + 1;
        end
    end
    while front < rear
        x = queue(front, 1);
        y = queue(front, 2);
        theta = queue(front, 3);
        if map(x, y, theta) <= TOLERANCE_RADIUS
            for k = 1 : size(NEIGHBOR, 1)
                tx = x + NEIGHBOR(k, 1);
                ty = y + NEIGHBOR(k, 2);
                if 1 <= tx && tx <= 200
                    if 1 <= ty && ty <= 200
                        if map(tx, ty, theta) == 0
                            map(tx, ty, theta) = map(x, y, theta) + 1;
                            queue(rear, :) = [tx, ty, theta];
                            rear = rear + 1;
                        end
                    end
                end
            end
        end
        front = front + 1;
    end
    map = map > 0;
end