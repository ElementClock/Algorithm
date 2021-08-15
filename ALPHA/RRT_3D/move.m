%{ This function uses coordinates, factor of value and epsilon criteria
% to move the branch further in the direction of new node selected by
% algorithm. If distance is very large, it will form a new node in the same
% direction as the nearest node selected to move before}
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