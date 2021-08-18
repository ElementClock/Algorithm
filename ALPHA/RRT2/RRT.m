clc,clear;close all;
%% 绘制障碍物(以球为例，主要是方便计算)
load Data
% circleCenter = [100,100,100;
%     50,50,50;
%     100,40,60;
%     150,100,100;
%     60,130,50];%圆心
% r=[50;
%     20;
%     20;
%     15;
%     15];%半径

%下面开始画
% figure(1);
% [x,y,z]=sphere;
% for i = 1:length(circleCenter(:,1))
%     mesh(r(i)*x+circleCenter(i,1),r(i)*y+circleCenter(i,2),r(i)*z+circleCenter(i,3));
%     hold on;
% end
axis equal
mesh(1:100,1:100,map.Z');
hold on;

%% 参数
source=[2 2 20];
goal=[100 100 35];
stepsize = 20;
threshold = 10;
maxFailedAttempts = 10000;
display = true;
searchSize = [100 100 70];      %探索空间六面体
%% 绘制起点和终点
hold on;
scatter3(source(1),source(2),source(3),"filled","g");
scatter3(goal(1),goal(2),goal(3),"filled","b");
tic;
RRTree = double([source -1]);
failedAttempts = 0;
pathFound = false;

%% 循环
while failedAttempts <= maxFailedAttempts  % loop to grow RRTs
    %% 选择随机配置
    if rand < 0.5
        sample = rand(1,3) .* searchSize;   % 随机抽样
    else
        sample = goal; % 将样本作为目标使树生成偏向于目标s
    end
    %% 选择 RRT 树中最接近 qrand 的节点
    [A, I] = min( distanceCost(RRTree(:,1:3),sample) ,[],1); % 找到每一列的最小值
    closestNode = RRTree(I(1),1:3);
    %% 从 qnearest 向 qrand 方向移动一个增量距离
    movingVec = [sample(1)-closestNode(1),sample(2)-closestNode(2),sample(3)-closestNode(3)];
    movingVec = movingVec/sqrt(sum(movingVec.^2));  %单位化
    newNode = closestNode + stepsize * movingVec;
    
    %% 如果将树中最近的节点扩展到新点是可行的
    % 球形障碍检验
%     if ~checkPath(closestNode, newNode, circleCenter,r)
%         failedAttempts = failedAttempts + 1;
%         continue;
%     end
    % 地型障碍检验
    if ~checkPath2(closestNode, newNode, terrainData,1)
        failedAttempts = failedAttempts + 1;
        continue;
    end
    
    %% 到达目标
    if distanceCost(newNode,goal) < threshold
        pathFound = true;
        break;
    end
    
    [A, I2] = min( distanceCost(RRTree(:,1:3),newNode) ,[],1); % 检查新节点是否已经存在于树中
    if distanceCost(newNode,RRTree(I2(1),1:3)) < threshold
        failedAttempts = failedAttempts + 1;
        continue
    end
    
    RRTree = [RRTree; newNode I(1)]; % add node
    failedAttempts = 0;
    if display
        plot3([closestNode(1);newNode(1)],[closestNode(2);newNode(2)],[closestNode(3);newNode(3)],'LineWidth',1);
    end
    pause(0.05);
end

if display && pathFound
    plot3([closestNode(1);goal(1)],[closestNode(2);goal(2)],[closestNode(3);goal(3)]);
end

% if display, disp('click/press any key'); waitforbuttonpress; end             %这个是设置等待点击后绘制最佳路径

if ~pathFound
    error('no path found. maximum attempts reached');
end
%% 从父信息中检索路径
path = goal;
prev = I(1);
while prev > 0
    path = [RRTree(prev,1:3); path];
    prev = RRTree(prev,4);
end

pathLength = 0;
for i=1:length(path(:,1))-1
    pathLength = pathLength + distanceCost(path(i,1:3),path(i+1,1:3));
end
pathLength=pathLength*30;%倍率
% 计算路径长度
toc
RRTime=toc;
disp(['规划路径长度为', num2str(pathLength)]);
%% 绘制结果图
% figure(2)
% for i = 1:length(circleCenter(:,1))
%     mesh(r(i)*x+circleCenter(i,1),r(i)*y+circleCenter(i,2),r(i)*z+circleCenter(i,3));hold on;
% end
axis equal
hold on;
scatter3(source(1),source(2),source(3),"filled","g");
scatter3(goal(1),goal(2),goal(3),"filled","b");
plot3(path(:,1),path(:,2),path(:,3),'LineWidth',2,'color','r');