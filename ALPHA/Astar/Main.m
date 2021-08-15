clear,clc;
load ('MapData1.mat');
WayPoints = [];
WayPointsAll = [];
OPEN_COUNT = 0;
OPEN_COUNT_ALL = 0;
%地形数据填充
% Cut_Data = Final_Data(301:400,101:200);
% MIN_Final_Data = min(min(Cut_Data));
tic%算法开始
timerVal = tic;
% startPoint=[20 20 7];
% targetPoint=[90 70 5];
startPoint=[1 1 10];
targetPoint=[100 100 17];
[WayPoints,OPEN_COUNT] = A_star(MAX_X,MAX_Y,MAX_Z,startPoint,targetPoint,MAP,CLOSED,Display_Data);
toc(timerVal)
WayL=0;
for num=1:length(WayPoints)-1
    WayL=WayL+distanced(WayPoints(num,1),WayPoints(num,2),WayPoints(num,3),WayPoints(num+1,1),WayPoints(num+1,2),WayPoints(num+1,3));
    WayL=WayL*65.57;%缩放倍率
end
%算法结束
elapsedTime = toc(timerVal);
% plotAstar;
ploTest;
