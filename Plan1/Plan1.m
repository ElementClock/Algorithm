clear all;
close all;
clc

%% 生成随机样本
n = 60;                     % 点数
m = 8;                      % 边界点候选数
d = 3;                        % 空间的维度
tol = 1e-07;                 % “inhull.m”中使用的公差值（较大的值高精度，可能有数值误差）
pos0 = 10*rand(n,d);         % 生成随机点

bnd0 = 10*rand(m,d);         % 生成边界点候选

K = convhull(bnd0);        %计算矩阵 P 中点的二维或三维凸包。
bnd_pnts = bnd0(K,:);   % 从与边界点候选者形成的凸多面体的顶点获取边界点
%% 取边界凸多面体中的点
in = inhull(pos0,bnd0,[],tol);
% inhull.m 由 John D'Errico 编写，它有效地检查点是否在 n 维的凸包内
% 我们使用该函数来选择定义边界内的点
u1 = 0;
for i = 1:size(pos0,1)
    if in(i) ==1
        u1 = u1 + 1;
        pos(u1,:) = pos0(i,:);
    end
end
%%
% =========================================================================
% 输入：
% pos   位于边界 n x d 矩阵中的 pos 点（n：点数 d：维度）
% bnd_pnts 点，定义边界 m x d 矩阵（m：凸多面体边界的顶点数 d：维度）
% -------------------------------------------------------------------------
% OUTPUTS:
% vornb     Voronoi neighbors for each generator point:     n x 1 cells 每个生成器点的 Voronoi 邻居：n x 1 个单元
% vorvx     Voronoi vertices for each generator point:      n x 1 cells     每个生成器点的 Voronoi 顶点：n x 1 个单元
% =========================================================================

[vornb,vorvx] = polybnd_voronoi(pos,bnd_pnts);

%% 绘图

for i = 1:size(vorvx,2)
    col(i,:)= rand(1,3);
end

switch d             %根据维度绘图
    case 2
        figure('position',[0 0 600 600],'Color',[1 1 1]);
        for i = 1:size(pos,1)
            plot(vorvx{i}(:,1),vorvx{i}(:,2),'-r')
            hold on;
        end
        plot(bnd_pnts(:,1),bnd_pnts(:,2),'-');
        hold on;
        plot(pos(:,1),pos(:,2),'Marker','o','MarkerFaceColor',[0 .75 .75],'MarkerEdgeColor','k','LineStyle','none');
        axis('equal')
        axis([0 1 0 1]);
        set(gca,'xtick',[0 1]);
        set(gca,'ytick',[0 1]);
    case 3
        figure('position',[0 0 600 600],'Color',[1 1 1]);
        for i = 1:size(pos,1)
            K = convhulln(vorvx{i});
            trisurf(K,vorvx{i}(:,1),vorvx{i}(:,2),vorvx{i}(:,3),'FaceColor',col(i,:),'FaceAlpha',0.5,'EdgeAlpha',1)
            hold on;
        end
        scatter3(pos(:,1),pos(:,2),pos(:,3),'Marker','o','MarkerFaceColor',[0 .75 .75], 'MarkerEdgeColor','k');
        axis('equal')
        axis([0 10 0 10 0 10]);   %坐标轴范围设置
        set(gca,'xtick',[0:10]);
        set(gca,'ytick',[0:10]);
        set(gca,'ztick',[0:10]);
        set(gca,'FontSize',16);
        xlabel('X');ylabel('Y');zlabel('Z');
        
end
