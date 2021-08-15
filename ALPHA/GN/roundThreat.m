%圆柱体威胁环境
function Map=roundThreat(Point,Radius,Tall,Map)
X=Point(1);
Y=Point(2);
for i=ceil(Point(1)-Radius:Point(1)+Radius)                           %X
    for j=ceil(Point(2)-Radius:Point(2)+Radius)                       %Y
        distance=pdist([X Y;i j],'euclidean');
        if distance<Radius
            Map.Z(i,j)=Tall;
        else
            Map.Z(i,j)=Map.Z(i,j);
        end
    end
end
end