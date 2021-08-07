% 该函数在 2D/3D 中找到两点之间的垂直平分线
% Hyongju Park / hyongju@gmail.com
% 输入：2D/3D 中的两点
% 输出：不等式 Ax <= b

function [A,b] = pbisec(x1, x2)

middle_pnt = mean([x1;x2],1);
n_vec = (x2 - x1) / norm(x2 - x1);
Ad = n_vec;
bd = dot(n_vec,middle_pnt);

if Ad * x1' <= bd
    A = Ad;
    b = bd;
else
    A = -Ad;
    b = -bd;
end
