% 这是代码中最重要的功能，用于避开最近节点策略找到的新方向上存在的所有障碍
function nc = ob_avoidance(n2, n1, ob_data)

A = [n1(1) n1(2) n1(3)]; % 要形成边的节点
B = [n2(1) n2(2) n2(3)]; % 要从上一个节点到达的节点
obs = [ob_data(1) ob_data(2) ob_data(3) ob_data(1)+ob_data(4) ob_data(2)+ob_data(5) ob_data(3)+ob_data(6)];

C1 = [obs(1),obs(2)];
D1 = [obs(1),obs(5)];
C2 = [obs(1),obs(2)];
D2 = [obs(4),obs(2)];
C3 = [obs(4),obs(5)];
D3 = [obs(4),obs(2)];
C4 = [obs(4),obs(5)];
D4 = [obs(1),obs(5)];
C5 = [obs(1) obs(3)];
D5 = [obs(1) obs(6)];
C6 = [obs(1) obs(3)];
D6 = [obs(4) obs(3)];
C7 = [obs(4) obs(6)];
D7 = [obs(4) obs(3)];
C8 = [obs(4) obs(6)];
D8 = [obs(1) obs(6)];
C9 = [obs(2) obs(3)];
D9 = [obs(2) obs(6)];
C10 = [obs(2) obs(3)];
D10 = [obs(5) obs(3)];
C11 = [obs(5) obs(6)];
D11 = [obs(5) obs(3)];
C12 = [obs(5) obs(6)];
D12 = [obs(2) obs(6)];

% 使用几何规则检查每条边和边的交点
val_con_1 = condition(A,C1,D1) ~= condition(B,C1,D1) && condition(A,B,C1) ~= condition(A,B,D1);
val_con_2 = condition(A,C2,D2) ~= condition(B,C2,D2) && condition(A,B,C2) ~= condition(A,B,D2);
val_con_3 = condition(A,C3,D3) ~= condition(B,C3,D3) && condition(A,B,C3) ~= condition(A,B,D3);
val_con_4 = condition(A,C4,D4) ~= condition(B,C4,D4) && condition(A,B,C4) ~= condition(A,B,D4);
val_con_5 = condition(A,C5,D5) ~= condition(B,C5,D5) && condition(A,B,C5) ~= condition(A,B,D5);
val_con_6 = condition(A,C6,D6) ~= condition(B,C6,D6) && condition(A,B,C6) ~= condition(A,B,D6);
val_con_7 = condition(A,C7,D7) ~= condition(B,C7,D7) && condition(A,B,C7) ~= condition(A,B,D7);
val_con_8 = condition(A,C8,D8) ~= condition(B,C8,D8) && condition(A,B,C8) ~= condition(A,B,D8);
val_con_9 = condition(A,C9,D9) ~= condition(B,C9,D9) && condition(A,B,C9) ~= condition(A,B,D9);
val_con_10 = condition(A,C10,D10) ~= condition(B,C10,D10) && condition(A,B,C10) ~= condition(A,B,D10);
val_con_11 = condition(A,C11,D11) ~= condition(B,C11,D11) && condition(A,B,C11) ~= condition(A,B,D11);
val_con_12 = condition(A,C12,D12) ~= condition(B,C12,D12) && condition(A,B,C12) ~= condition(A,B,D12);

% 只允许安全无碰撞的运动
if val_con_1==0 && val_con_2==0 && val_con_3==0 && val_con_4==0 && val_con_5==0 && val_con_6==0 && val_con_7==0 && val_con_8==0 && val_con_9==0 && val_con_10==0 && val_con_11==0 && val_con_12==0
    nc = 1;
else
    nc = 0;
end
end