%球形检验
function feasible=checkPath(n,newPos,circleCenter,r)
feasible=true;
movingVec = [newPos(1)-n(1),newPos(2)-n(2),newPos(3)-n(3)];
movingVec = movingVec/sqrt(sum(movingVec.^2)); %单位化
for R=0:0.5:sqrt(sum((n-newPos).^2))
    posCheck=n + R .* movingVec;
    if ~(feasiblePoint(ceil(posCheck),circleCenter,r) && feasiblePoint(floor(posCheck),circleCenter,r))
        feasible=false;break;
    end
end
if ~feasiblePoint(newPos,circleCenter,r)
    feasible=false;
end
end