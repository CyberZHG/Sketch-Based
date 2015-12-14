function Dist = angle_dist(Angle1, Angle2)
Dist = abs(Angle1 - Angle2);
while Dist < 0.0
    Dist = Dist + pi * 2;
end
if Dist > pi
    Dist = 2 * pi - Dist;
end
