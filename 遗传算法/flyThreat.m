function [Map]=flyThreat(flyPoint,Map)
flyPoint(:,1:2)=flyPoint(:,1:2)/30;  %提取位置点
flyPoint(:,3)=flyPoint(:,3);  %提取位置点
Size=size(flyPoint);
for i=10:1:Size(1)-5          %减5避免边界冲突
Tall=flyPoint(i,3);
Radius=5;
Map=roundThreat(flyPoint(i,1:2),Radius,Tall,Map);
end
end