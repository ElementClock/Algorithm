%长方体威胁环境

function    [Map]=rectangleThreat(Point,Length,Width,Tall,Map)          %笛卡尔
X=Point(1);
Y=Point(2);
% Map.Z(X:X+Length,Y:Y+Width)=Map.Z(X:X+Length,Y:Y+Width)+Tall;  %加高模式
% Map.Z(Y:Y+Width,X:X+Length)=Tall;      %定高模式
Map.Z(X:X+Length,Y:Y+Width)=Tall;      %定高模式
%x轴在列，y轴是行
end