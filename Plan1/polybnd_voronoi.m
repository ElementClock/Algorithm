function [vornb,vorvx,Aaug,baug] = polybnd_voronoi(pos,bnd_pnts)
%% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% [Voronoi neighbor,Voronoi vertices] = voronoi_3d(points, boundary)
% 给定 n 个点在 R^2/R^3 中的有界空间，该函数计算与每个点关联的
% Voronoi 邻居/多边形（作为生成器）。
% =========================================================================
% INPUTS:
% pos     边界内的点      n x d 矩阵（n：点数 d：维度）
% bnd_pnts   定义边界的点  m x d matrix (m: number of vertices for the convex polytope
% boundary d: dimension)
% -------------------------------------------------------------------------
% OUTPUTS:
% vornb    每个生成器点的 Voronoi 邻居：n x 1 个单元
% vorvx     每个生成器点的 Voronoi 顶点：n x 1 个单元
% =========================================================================
% This functions works for d = 2, 3
% -------------------------------------------------------------------------
% 此功能需要：
% vert2lcon.m (Matt Jacobson / Michael Keder)
% pbisc.m（由我）
% con2vert.m (迈克尔·凯德)
% -------------------------------------------------------------------------
%% Written by Hyongju Park, hyongju@gmail.com / park334@illinois.edu

K = convhull(bnd_pnts);
bnd_pnts = bnd_pnts(K,:);

[Abnd,bbnd] = vert2lcon(bnd_pnts); 
% 获得凸多面体边界的不等式约束
% vert2lcon.m by Matt Jacobson，它是'vert2con'的扩展
% 迈克尔·凯德
% 使用 Delaunay 三角剖分查找 Voronoi 邻居
switch size(pos,2)
    case 2
        TRI = delaunay(pos(:,1),pos(:,2));        
    case 3
        TRI = delaunay(pos(:,1),pos(:,2),pos(:,3));        
end

for i = 1:size(pos,1)
    k = 0;
    for j = 1:size(TRI,1)
        if ~isempty(MY_intersect(i,TRI(j,:)))
            k = k + 1;
            neib2{i}(k,:) = MY_setdiff(TRI(j,:),i);
        end
    end
    neib3{i} = unique(neib2{i});
    if size(neib3{i},1) == 1
        vornb{i} = neib3{i};
    else
        vornb{i} = neib3{i}';
    end
end
% 获得垂直平分线
for i = 1:size(pos,1)
    k = 0;
    for j = 1:size(vornb{i},2)
        k = k + 1;
        [A{i}(k,:),b{i}(k,:)] = pbisec(pos(i,:), pos(vornb{i}(j),:));
    end
end
% 获得平分线+边界之间的MY_intersection

for i = 1:size(pos,1)
    Aaug{i} = [A{i};Abnd];
    baug{i} = [b{i};bbnd];
end

% 将不等式约束集转换为顶点集
% Michael Kleder 使用“con2vert.m”的那些不等式的交集
for i =1:size(pos,1)
   V{i}= MY_con2vert(Aaug{i},baug{i});
   ID{i} = convhull(V{i});
   vorvx{i} = V{i}(ID{i},:);
end
