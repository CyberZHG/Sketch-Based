function ret = draw_line(I, y1, x1, y2, x2)
    y1 = round(y1);
    x1 = round(x1);
    y2 = round(y2);
    x2 = round(x2);
    ret = I;
    if x1 == x2
        for y = y1 : sign(y2 - y1) : y2
            ret(y, x1, :) = 1;
        end
    else
        deltax = x2 - x1;
        deltay = y2 - y1;
        error = 0;
        deltaerr = abs(deltay / deltax);
        y = y1;
        for x = x1 : sign(x2 - x1) : x2
            ret(y, x, :) = 1;
            error = error + deltaerr;
            while error >= 0.5
                y = y + sign(y2 - y1);
                error = error - 1.0;
                ret(y, x, :) = 1;
            end
        end
    end
end
