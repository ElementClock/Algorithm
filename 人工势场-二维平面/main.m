clc,clear,close all;
load P1;%获取图像
limitL=length(P1(1,:,1));
limitW=length(P1(:,1,1));
fpoint=[limitL/2,limitW/2 ];%飞行当前位置%
fpoint=[0,0];
count=1;

for i=1:limitW
    for j=1:limitL
    if P1(i,j,1)>=220&& P1(i,j,2)>=220 && P1(i,j,3)>=220%过滤红色
    rpoint(count,:)=[i,j];
    count=count+1;
    end
    end
end






return;
begin=[1;1];%起点
over=[14;14];%终点
obstacle=[5 8 10 7 10 5 ;5 6 9 9 13 10];
hold on;
plot(begin(1),begin(2),'*b','MarkerSize',10);
plot(over(1),over(2),'*b','MarkerSize',10);

plot(obstacle(1,:),obstacle(2,:),'ob');
 for i=1:size(obstacle,2)
    rectangle('Position',[obstacle(1,i)-0.5,obstacle(2,i)-0.5,1,1],'Curvature',[1,1],'FaceColor','r');
 end
 
 %% 制导
point= path_plan(begin,over,obstacle);
