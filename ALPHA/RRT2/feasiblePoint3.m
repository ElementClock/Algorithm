function feasible=feasiblePoint3(point,circleCenter,r)
feasible=true;
% 检查无碰撞点和内部地图
for row = 1:length(circleCenter(:,1))
    if sqrt(sum((circleCenter(row,:)-point).^2)) <= r(row)
        feasible = false;break;
    end
end
end