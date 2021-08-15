clc;clear all;close all;
load alphaMap;
%机器人地图或到达空间的边界
x_max = 600;
y_max = 600;
z_max = 600;
% 绘图以查看其收敛方式并为机器人找到最佳路径
figure()
axis([0 x_max 0 y_max 0 z_max])
title('算法寻找路径的可视化模拟')
xlabel('X')
ylabel('Y')
zlabel('Z')
hold on
compare = 40;                                        % 用于限制特定范围内移动的值
Max_num_Nodes = 1600;                        %允许的最大节点数量
q_start.config = [0 0 0];                           % 机器人初始位置
q_start.cost = 0;                                      % 到达节点的成本
q_start.parent = 0;                                  % parent 是它通过的节点
q_goal.config = [500 500 100];                % 目的地
q_goal.cost = 0;                                      % 成本的初始化
nodes(1) = q_start;                                 % 定义第一个节点作为起始位置
%绘制起点
plot3(q_start.config(1), q_start.config(2), q_start.config(3), 'o',...
    'LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','b',...
    'MarkerSize',14);
%绘制终点
plot3(q_goal.config(1), q_goal.config(2), q_goal.config(3), 'o',...
    'LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','r',...
    'MarkerSize',14);
%此处定义的障碍百分比
% 添加新障碍物和修改任何现有障碍物非常简单快捷，只需更改任何障碍物的参数
p_obstacle=[150,50,0];                %角上的点
size_obstacle=[120,100,200];
p_obstacle2=[350,350,0];
size_obstacle2=[100,100,180];
obstacle(size_obstacle,p_obstacle,1,[0 0 1]);                 %正方体障碍
hold on
obstacle(size_obstacle2,p_obstacle2,1,[0 0 1]);
hold on
% %绘制圆柱体障碍
% R0=40;x0=200;y0=400;z0=0;h1=180;
% R02=30;x02=500;y02=150;z02=0;h2=190;
% R03=50;x03=500;y03=300;z03=0;h3=160;
% R04=40;x04=350;y04=250;z04=0;h4=190;
% cyl_obs(x0,y0,z0,R0,h1)
% cyl_obs(x02,y02,z02,R02,h2)
% cyl_obs(x03,y03,z03,R03,h3)
% cyl_obs(x04,y04,z04,R04,h4)

% 以矩阵形式提供每个障碍物的数据以供稍后使用
ob(1,1:6)=[p_obstacle(1), p_obstacle(2),p_obstacle(3), size_obstacle(1), size_obstacle(2), size_obstacle(3)];
ob(2,1:6)=[p_obstacle2(1), p_obstacle2(2), p_obstacle2(3), size_obstacle2(1), size_obstacle2(2), size_obstacle2(3)];
% ob(3,1:6)=[x0-R0, y0-R0,z0-R0 2*R0, 2*R0, h1];
% ob(4,1:6)=[x02-R02, y02-R02, z02-R02 2*R02, 2*R02, h2];
% ob(5,1:6)=[x03-R03, y03-R03, z03-R03, 2*R03, 2*R03, h3];
% ob(6,1:6)=[x04-R04, y04-R04, z04-R04, 2*R04, 2*R04, h4];

tic;
%计时开始
%RRT 算法从这里开始，循环继续直到节点数没有达到输入允许的最大值
for i = 1:1:Max_num_Nodes
    q_rand = [rand(1)*x_max rand(1)*y_max rand(1)*z_max];
    plot3(q_rand(1), q_rand(2), q_rand(3), 'x', 'Color','r');
    hold on
    legend({'Start Node','Goal Node'},'Location','northeast')
    
    % 一个条件，使用 break 命令，如果机器人到达目标节点并满足要求，则退出循环
    for j = 1:1:length(nodes)
        if nodes(j).config == q_goal.config
            break
        end
    end
    
    % 比较当前节点和新节点之间的距离以从一组随机节点中找到最近的节点
    n_dist = [];
    for j = 1:1:length(nodes)
        n = nodes(j);
        dist_tmp = euc_dist_3d(n.config, q_rand);    %每个已构建的点与随机点的欧式几何距离
        n_dist = [n_dist dist_tmp];                           %在n_dist后面增加距离值
    end
    
    [val, idx] = min(n_dist);           %返回最小值的值和索引
    q_near = nodes(idx);               %最近点
    q_new.config = move(q_rand, q_near.config, val, compare);
    
    
    % 以下'if'条件使用最后提供的函数检查找到的边缘是否与任何障碍物发生碰撞
    if ob_avoidance(q_rand, q_near.config, ob(1,:)) && ob_avoidance(q_rand, q_near.config, ob(2,:))% && ob_avoidance(q_rand, q_near.config, ob(3,:)) && ob_avoidance(q_rand, q_near.config, ob(4,:)) && ob_avoidance(q_rand, q_near.config, ob(5,:)) && ob_avoidance(q_rand, q_near.config, ob(6,:))
        line([q_near.config(1), q_new.config(1)], [q_near.config(2), q_new.config(2)], [q_near.config(3), q_new.config(3)], 'Color', 'm', 'LineWidth', 2);
        drawnow; % 此命令显示收敛的实际绘图
        hold on
        q_new.cost = euc_dist_3d(q_new.config, q_near.config) + q_near.cost;
        q_nearest = [];
        r = 50;
        neighbor_count = 1;
        for j = 1:1:length(nodes)
            if (euc_dist_3d(nodes(j).config, q_new.config)) <= r && ob_avoidance(q_rand, q_near.config, ob(1,:)) && ob_avoidance(q_rand, q_near.config, ob(2,:)) %&& ob_avoidance(q_rand, q_near.config, ob(3,:)) && ob_avoidance(q_rand, q_near.config, ob(4,:)) && ob_avoidance(q_rand, q_near.config, ob(5,:)) && ob_avoidance(q_rand, q_near.config, ob(6,:))
                q_nearest(neighbor_count).config = nodes(j).config;
                q_nearest(neighbor_count).cost = nodes(j).cost;
                neighbor_count = neighbor_count+1;
            end
        end
        
        % 比较通过不同节点到最近节点的成本，最后选择成本最低的节点
        q_min = q_near;
        C_min = q_new.cost;
        for k = 1:1:length(q_nearest)
            if q_nearest(k).cost + euc_dist_3d(q_nearest(k).config, q_new.config) < C_min && ob_avoidance(q_rand, q_near.config, ob(1,:)) && ob_avoidance(q_rand, q_near.config, ob(2,:)) %&& ob_avoidance(q_rand, q_near.config, ob(3,:)) && ob_avoidance(q_rand, q_near.config, ob(4,:)) && ob_avoidance(q_rand, q_near.config, ob(5,:)) && ob_avoidance(q_rand, q_near.config, ob(6,:))
                q_min = q_nearest(k);
                C_min = q_nearest(k).cost + euc_dist_3d(q_nearest(k).config, q_new.config);
                line([q_min.config(1), q_new.config(1)], [q_min.config(2), q_new.config(2)], [q_min.config(3), q_new.config(3)], 'Color', 'b');
                hold on
            end
        end
        
        for j = 1:1:length(nodes)
            if nodes(j).config == q_min.config
                q_new.parent = j;
            end
        end
        nodes = [nodes q_new];
    end
end
toc


% 通过形成具有距离的向量来寻找最短距离路径
D = [];
for j = 1:1:length(nodes)
    tmp_dist = euc_dist_3d(nodes(j).config, q_goal.config);
    D = [D tmp_dist];
end

% 比较上面形成的向量的元素并找到它的最小距离以获得最终路径如果最后选择的节点不是目标节点
% 我们替换它并在节点列表的末尾添加目标节点
[val, idx] = min(D);
q_goal.parent = idx;
q_end = q_goal;
nodes = [nodes q_goal];

% 以下循环有助于连接从最后一个节点到目标节点的路径，如果最大节点数不足以达到
while q_end.parent ~= 0
    start = q_end.parent;
    data1=line([q_end.config(1), nodes(start).config(1)], [q_end.config(2), nodes(start).config(2)], [q_end.config(3), nodes(start).config(3)], 'Color', 'g', 'LineWidth', 4);
    hold on
    q_end = nodes(start);
end
label(data1,'Final Path')