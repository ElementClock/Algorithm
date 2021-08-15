%% 该函数用于演示基于蚁群算法的三维路径规划算法

%% 清空环境
clc
clear

%% 数据初始化
% load alphaMap;
% HeightData=double(map.Z);


HeightData = [2000 1400 800 650 500 750 1000 950 900 800 700 900 1100 1050 1000 1150 1300 1250 1200 1350 1500;
   1100 900 700 625 550 825 1100 1150 1200 925 650 750 850 950 1050 1175 1300 1350 1400 1425 1450;
   200 400 600 600 600 900 1200 1350 1500 1050 600 600 600 850 1100 1200 1300 1450 1600 1500 1400;
   450 500 550 575 600 725 850 875 900 750 600 600 600 725 850 900 950 1150 1350 1400 1450;
   700 600 500 550 600 550 500 400 300 450 600 600 600 600 600 600 600 850 1100 1300 1500;
   500 525 550 575 600 575 550 450 350 475 600 650 700 650 600 600 600 725 850 1150 1450;
   300 450 600 600 600 600 600 500 400 500 600 700 800 700 600 600 600 600 600 1000 1400;
   550 525 500 550 600 875 1150 900 650 725 800 700 600 875 1150 1175 1200 975 750 875 1000;
   800 600 400 500 600 1150 1700 1300 900 950 1000 700 400 1050 1700 1750 1800 1350 900 750 600;
   650 600 550 625 700 1175 1650 1275 900 1100 1300 1275 1250 1475 1700 1525 1350 1200 1050 950 850;
   500 600 700 750 800 1200 1600 1250 900 1250 1600 1850 2100 1900 1700 1300 900 1050 1200 1150 1100;
   400 375 350 600 850 1200 1550 1250 950 1225 1500 1750 2000 1950 1900 1475 1050 975 900 1175 1450;
   300 150 0 450 900 1200 1500 1250 1000 1200 1400 1650 1900 2000 2100 1650 1200 900 600 1200 1800;
   600 575 550 750 950 1275 1600 1450 1300 1300 1300 1525 1750 1625 1500 1450 1400 1125 850 1200 1550;
   900 1000 1100 1050 1000 1350 1700 1650 1600 1400 1200 1400 1600 1250 900 1250 1600 1350 1100 1200 1300;
   750 850 950 900 850 1000 1150 1175 1200 1300 1400 1325 1250 1125 1000 1150 1300 1075 850 975 1100;
   600 700 800 750 700 650 600 700 800 1200 1600 1250 900 1000 1100 1050 1000 800 600 750 900;
   750 775 800 725 650 700 750 775 800 1000 1200 1025 850 975 1100 950 800 900 1000 1050 1100;
   900 850 800 700 600 750 900 850 800 800 800 800 800 950 1100 850 600 1000 1400 1350 1300;
   750 800 850 850 850 850 850 825 800 750 700 775 850 1000 1150 875 600 925 1250 1100 950;
   600 750 900 1000 1100 950 800 800 800 700 600 750 900 1050 1200 900 600 850 1100 850 600];


%网格划分
LevelGrid=10;
PortGrid=21;

%起点终点网格点 
starty=10;starth=4;
endy=8;endh=5;
m=10;
%算法参数
PopNumber=100;         %种群个数
BestFitness=[];    %最佳个体

%初始信息素
pheromone=ones(21,21,21);

%% 初始搜索路径
[path,pheromone]=searchpath(PopNumber,LevelGrid,PortGrid,pheromone, HeightData,starty,starth,endy,endh); 
fitness=CacuFit(path);                          %适应度计算
[bestfitness,bestindex]=min(fitness);           %最佳适应度
bestpath=path(bestindex,:);                     %最佳路径
BestFitness=[BestFitness;bestfitness];          %适应度值记录
 
%% 信息素更新
rou=0.2;
cfit=100/bestfitness;
for i=2:PortGrid-1
    pheromone(i,bestpath(i*2-1),bestpath(i*2))= (1-rou)*pheromone(i,bestpath(i*2-1),bestpath(i*2))+rou*cfit;
end
    
%% 循环寻找最优路径
for kk=1:200 %这里改迭代次数
     kk  %迭代次数
    %% 路径搜索
    [path,pheromone]=searchpath(PopNumber,LevelGrid,PortGrid,pheromone,HeightData,starty,starth,endy,endh); 
    
    %% 适应度值计算更新
    fitness=CacuFit(path);                               
    [newbestfitness,newbestindex]=min(fitness);     
    if newbestfitness<bestfitness
        bestfitness=newbestfitness;
        bestpath=path(newbestindex,:);
    end 
    BestFitness=[BestFitness;bestfitness];
    
    %% 更新信息素
    cfit=100/bestfitness;
    for i=2:PortGrid-1
        pheromone(i,bestpath(i*2-1),bestpath(i*2))=(1-rou)* pheromone(i,bestpath(i*2-1),bestpath(i*2))+rou*cfit;
    end
 
end

%% 最佳路径
for i=1:21
    a(i,1)=bestpath(i*2-1);
    a(i,2)=bestpath(i*2);
end
figure(1)
x=1:21;
y=1:21;
[x1,y1]=meshgrid(x,y);
mesh(x1,y1,HeightData)
axis([1,21,1,21,0,2000])
hold on
% axis('equal');
k=1:21;
plot3(k(1)',a(1,1)',a(1,2)'*200,'-o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',7)
plot3(k(21)',a(21,1)',a(21,2)'*200,'-o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',7)
text(k(1)',a(1,1)',a(1,2)'*200,'   起点');
text(k(21)',a(21,1)',a(21,2)'*200,'    终点');
xlabel('km','fontsize',12);
ylabel('km','fontsize',12);
zlabel('m','fontsize',12);
title('三维路径规划空间','fontsize',12)
set(gcf, 'Renderer', 'ZBuffer')
hold on
plot3(k',a(:,1)',a(:,2)'*200,'r-o')

%% 适应度变化
figure(2)
plot(BestFitness)
title('最佳个体适应度变化趋势')
xlabel('迭代次数')
ylabel('适应度值')