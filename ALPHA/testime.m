function [T,L]=testime(flag)
switch flag
    case 1
        Plan;
        T=GNtime;
        L=path_value_true(pos);
    case 2
        Main;
        T=elapsedTime;
        L=WayL;
    case 3
        RRT;
        T=RRTime;
        L=pathLength;
end
end
