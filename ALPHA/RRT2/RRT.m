clc,clear;
%% 绘制障碍物(以球为例，主要是方便计算)
load alphaMap
data=double(map.Z);
circleCenter = [100,100,100;50,50,50;100,40,60;150,100,100;60,130,50];
r=[50;20;20;15;15];%半径
%下面开始画
figure(1);
[x,y,z]=sphere;
for i = 1:length(circleCenter(:,1))
    mesh(r(i)*x+circleCenter(i,1),r(i)*y+circleCenter(i,2),r(i)*z+circleCenter(i,3));hold on;
end
axis equal


%% 参数
source=[10 10 10];
goal=[150 150 150];
stepsize = 10;
threshold = 10;
maxFailedAttempts = 10000;
display = true;
searchSize = [250 250 250];      %探索空间六面体
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
    newPoint = closestNode + stepsize * movingVec;
    if ~checkPath(closestNode, newPoint, circleCenter,r) % 如果将树中最近的节点扩展到新点是可行的s
        failedAttempts = failedAttempts + 1;
        continue;
    end
    
    if distanceCost(newPoint,goal) < threshold
        pathFound = true; 
        break;
    end % 到达目标
    [A, I2] = min( distanceCost(RRTree(:,1:3),newPoint) ,[],1); % 检查新节点是否已经存在于树中
    if distanceCost(newPoint,RRTree(I2(1),1:3)) < threshold
        failedAttempts = failedAttempts + 1; 
        continue
    end 
    
    RRTree = [RRTree; newPoint I(1)]; % add node
    failedAttempts = 0;
    if display
        plot3([closestNode(1);newPoint(1)],[closestNode(2);newPoint(2)],[closestNode(3);newPoint(3)],'LineWidth',1);
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
end % 计算路径长度

fprintf('processing time=%d \nPath Length=%d \n\n', toc, pathLength); 
%绘制结果图
figure(2)
for i = 1:length(circleCenter(:,1))
    mesh(r(i)*x+circleCenter(i,1),r(i)*y+circleCenter(i,2),r(i)*z+circleCenter(i,3));hold on;
end
axis equal
hold on;
scatter3(source(1),source(2),source(3),"filled","g");
scatter3(goal(1),goal(2),goal(3),"filled","b");
plot3(path(:,1),path(:,2),path(:,3),'LineWidth',2,'color','r');