clear,clc;
load ('MapData.mat');
WayPoints = [];
WayPointsAll = [];
OPEN_COUNT = 0;
OPEN_COUNT_ALL = 0;
%�����������
Cut_Data = Final_Data(301:400,101:200);
MIN_Final_Data = min(min(Cut_Data));

tic%�㷨��ʼ
timerVal = tic
[WayPoints,OPEN_COUNT] = A_star(MAX_X,MAX_Y,MAX_Z,20,20,7,90,70,5,MAP,CLOSED,Display_Data);
toc(timerVal)
%�㷨����

elapsedTime = toc(timerVal)
%��ͼ
figure(1)
axis([1 MAX_X 1 MAX_Y 1 MAX_Z]);
plot3(WayPoints(:,1),WayPoints(:,2),WayPoints(:,3),'b','linewidth',2);
hold on
surf(Display_Data(1:100,1:100)','linestyle','none');
plot3(20,20,7,'*');
plot3(90,70,5,'^');
set(gca,'xticklabel','');
set(gca,'yticklabel','');
set(gca,'zticklabel',{'2000','4000','6000','4000','5000','6000','7000','8000','9000','10000'});
xlabel('γ��');
ylabel('����');
zlabel('�߶ȣ�m��');
grid on
%���ƴ�ֱ���溽ͼ
figure(2)
X_WayPoints = WayPoints(end:-1:1,1);
Y_WayPoints = WayPoints(end:-1:1,2);
Z_WayPoints = WayPoints(end:-1:1,3);
Total_X_WayPoints = [20 X_WayPoints'];
Total_Y_WayPoints = [20 Y_WayPoints'];
Total_Z_WayPoints = [7 Z_WayPoints'];
Terrain_Data = Final_Data(301:400,101:200);
num = size(Total_X_WayPoints);
for i= 1:num(1,2)
    Terrain_Z_WayPoints(i) = Terrain_Data(Total_X_WayPoints(1,i),Total_Y_WayPoints(1,i));
end
lat_lonD = [];
lat_lonDisReal = [];
lat_lonDisReal(1) = 0;
plat = (37.3565 - (25/54)*Total_X_WayPoints./100)';
plon = (101.7130 + (25/54)*Total_Y_WayPoints./100)';
pi=3.1415926;
num = size(plat)-1;
for i = 1:num(1,1)
    lat_lonD(i)=distance(plat(i),plon(i),plat(i+1),plon(i+1));
    lat_lonD(i)=lat_lonD(i)*6371*2*pi/360;
    lat_lonDisReal(i+1) = lat_lonDisReal(i) + lat_lonD(i);
end
MIN_Final_Data = min(min(Final_Data(301:400,101:200)));
Total_Z_WayPoints = Total_Z_WayPoints.*100 + MIN_Final_Data;
h1 = plot(lat_lonDisReal,Total_Z_WayPoints,'b');
hold on
plot(lat_lonDisReal,Terrain_Z_WayPoints,'c');
h2 = plot(lat_lonDisReal,Terrain_Z_WayPoints + 1000,'r');
X_fill = lat_lonDisReal;
Y_fill = Terrain_Z_WayPoints;
Y_size = size(Y_fill);
Y_fill_low = zeros(Y_size(1,1),Y_size(1,2));
X_fillfor = [fliplr(X_fill),X_fill];
Y_fillfor = [fliplr(Y_fill_low),Y_fill];
h3 = fill(X_fillfor,Y_fillfor,'c','FaceAlpha',1,'EdgeAlpha',0.3,'EdgeColor','k');
hleg = legend([h1,h2,h3],'�滮������ֱ����ͶӰ','�Ϳշ����ϱ߽�','���δ�ֱ����');
set(hleg,'Location','NorthWest','Fontsize',8);
hold off
xlabel('����·�̣�km��');
ylabel('���и߶ȣ�m��');
xmaxTeam = lat_lonDisReal(1,num+1);
xmax = xmaxTeam(1,1);
axis([0 xmax 2500 5500]);
grid on