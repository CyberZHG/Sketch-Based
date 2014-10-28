function ret = draw_line(I, y1, x1, y2, x2, color)

ret = I;
if x1 == x2
    if y1 <= y2
        for y = y1 : y2
            ret(y, x1, :) = 220;
        end
    else
        for y = y2 : y1
            ret(y, x2, :) = 220;
        end
    end
else
    k = (y2 - y1) / (x2 - x1);
    b = y1 - k * x1;
    x = linspace(x1, x2, 1000);
    y = k * x + b;
    for i = 1 : length(x)
        ret(round(y(i)), round(x(i)), :) = 220;
    end
end