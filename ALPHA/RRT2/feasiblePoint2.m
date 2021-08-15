function feasible=feasiblePoint2(point,terrainData,distaceLand) %地形碰撞检验
feasible=true;

for row = 1:length(terrainData(:,1))
    %如果当前检验点的距离是否小于地表距离
    if sqrt(sum((terrainData(row,:)-point).^2)) <= distaceLand
        feasible = false;
        break;
    end
end
end