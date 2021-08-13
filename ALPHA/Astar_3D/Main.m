clear,clc;
load ('MapData.mat');
WayPoints = [];
WayPointsAll = [];
OPEN_COUNT = 0;
OPEN_COUNT_ALL = 0;
%地形数据填充
Cut_Data = Final_Data(301:400,101:200);
MIN_Final_Data = min(min(Cut_Data));
tic%算法开始
timerVal = tic
[WayPoints,OPEN_COUNT] = A_star(MAX_X,MAX_Y,MAX_Z,20,20,7,90,70,5,MAP,CLOSED,Display_Data);
toc(timerVal)
%算法结束
elapsedTime = toc(timerVal);
plotAstar;
