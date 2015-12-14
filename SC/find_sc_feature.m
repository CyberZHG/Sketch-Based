function [Success, Matches, Visit] = find_sc_feature(i, Dists, Matches, Visit, Dummy)
M = size(Dists, 2);
Success = 0;
for j = 1 : M
    if Visit(j) == 0
        Visit(j) = 1;
        if Matches(j) == 0
            if Dists(i, j) < Dummy
                Matches(j) = i;
                Success = 1;
                break
            end
        else
            if Dists(i, j) < Dummy && Dists(i, j) + 1e-8 < Dists(Matches(j), j)
                [S, Matches, Visit] = find_sc_feature(Matches(j), Dists, Matches, Visit, Dummy);
                if S == 1
                    Matches(j) = i;
                    Success = 1;
                    break
                end
            end
        end
    end
end
