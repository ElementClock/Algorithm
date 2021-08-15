%该函数使用坐标、值的因子和 epsilon 标准在算法选择的新节点的方向上进一步移动分支。 
%如果距离非常大，就会形成一个新的节点，与之前选择移动的最近节点同方向
function A = move(qr, qn, val, eps)
q_new = [0 0];
if val >= eps
    q_new(1) = qn(1) + ((qr(1)-qn(1))*eps)/euc_dist_3d(qr,qn);
    q_new(2) = qn(2) + ((qr(2)-qn(2))*eps)/euc_dist_3d(qr,qn);
    q_new(3) = qn(3) + ((qr(3)-qn(3))*eps)/euc_dist_3d(qr,qn);
else
    q_new(1) = qr(1);
    q_new(2) = qr(2);
    q_new(3) = qr(3);
end
A = [q_new(1), q_new(2), q_new(3)];
end