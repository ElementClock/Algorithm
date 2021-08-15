function feasible=feasiblePoint(point,circleCenter,r) %地形碰撞检验
feasible=true;

for row = 1:length(circleCenter(:,1))
    %如果当前检验点的距离是否小于球体半径
    if sqrt(sum((circleCenter(row,:)-point).^2)) <= r(row)
        feasible = false;
        break;
    end
end
end