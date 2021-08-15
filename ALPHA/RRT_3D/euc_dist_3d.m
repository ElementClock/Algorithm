% 计算两个给定节点之间的欧氏距离的简单函数
function d = euc_dist_3d(q1,q2)
d = sqrt((q1(1)-q2(1))^2 + (q1(2)-q2(2))^2 + (q1(3)-q2(3))^2);
end