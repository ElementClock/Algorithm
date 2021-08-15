function feasible=checkPath2(closeNode,newNode,terrainData,distaceLand)   %地形检验
%closeNode为最近节点
%newPos为新节点

feasible=true;
%前进向量
movingVec = [newNode(1)-closeNode(1),newNode(2)-closeNode(2),newNode(3)-closeNode(3)];
movingVec = movingVec/sqrt(sum(movingVec.^2)); %单位化

distClose2New=sqrt(sum((closeNode-newNode).^2));%最近点到最新点的距离

%检验移动过程是否穿透障碍
for R=0:0.5:distClose2New
    posCheck=closeNode + R .* movingVec;
    if ~(feasiblePoint2(ceil(posCheck),terrainData,distaceLand) && feasiblePoint2(floor(posCheck),terrainData,distaceLand))
        feasible=false;
        break;
    end
end

%检验新点是否在障碍内
if ~feasiblePoint2(newNode,terrainData,distaceLand)
    feasible=false;
end

end