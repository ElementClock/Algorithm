%%主程序
clear;
clc;
close all;
tic;
%%载入地图,地图xy相邻间隔为38.2m
dem=load('DEM.mat');
map.Z=dem.DEM(401:701,401:701);%%原 4 7
map.X=1:301;
map.Y=1:301;
map.gap=38.2;%%相邻间隔
hmin=min(min(map.Z));%%用来画图                    如果只用一个min，得出的结果是每一列的最小值，下同
hmax=max(max(map.Z));


%%模拟退火算法部分参数
t0=9*10^3;%%初始温度
t=10;%%结束温度
r=0.95;%%降温系数t0=r*t0

%%遗传算法部分参数
NP=5000;%%种群数量
max_gen=ceil(log(t/t0)/log(r));    %种群进化次数                          %Y = ceil(X)将 的每个元素四舍五入X到最接近的大于或等于该元素的整数。
pathnum=60;%%路径点个数
%%改变概率
pc0=0.7;%%交叉概率
pv0=0.1;%%变异概率
pcmin=0.1;
pvmin=0.02;
a=0.5;%%路径长度比重
b=0.25;%%偏航角比重
c=0.25;%%俯仰角比重
%%初始点部分
p_start=[1,1,map.Z(1,1)+50];%%起始点坐标（1，1，Z）
p_end=[301,301,map.Z(size(map.X,2),size(map.X,2))+50];

%%path就是DNA
%%产生初始种群
path=zeros(NP,pathnum,3);%%1是x坐标，2是y坐标，3是z坐标
for i=1:1:NP
    for k=1:1:3 %%初始起点和终点
        path(i,1,k)=p_start(k);
        path(i,pathnum,k)=p_end(k);
    end
    x0=rand(1);
    
    for j=2:1:pathnum-1
        path(i,j,1)=1+(j-1)*floor(300/pathnum);
        %logistic混沌
        x1=4*x0*(1-x0);
        path(i,j,2)=round(1+x1*(301-1));
        x0=x1;
        path(i,j,3)=map.Z(path(i,j,1),path(i,j,2))+randi([50,250],1,1);
    end
end

%初始化各类函数
mean_path_value_true=zeros(1,max_gen);%%初始化平均路径长度
min_path_value_true=zeros(1,max_gen);%%初始化最短路径长度
mean_yaw_value_true=zeros(1,max_gen);%%初始化平均偏航角真值
min_yaw_value_true=zeros(1,max_gen);%%初始化最小偏航角真值
mean_pitch_value_true=zeros(1,max_gen);%%初始化平均俯仰角真值
min_pitch_value_true=zeros(1,max_gen);%%初始化最小俯仰角真值

%%计算初始适应度
[path_value_true,path_value]=cal_path_value(path,map);%%路径值
[yaw_value_true,yaw_value]=cal_yaw_value(path);%%偏航角情况
[pitch_value_true,pitch_value]=cal_pitch_value(path,map);%%俯仰角情况


%%选择、交叉、变异过程
for n=1:1:max_gen
    fprintf('第%d次进化，已完成%.1f%%\n',n,n/max_gen*100);
    pc=pc0-(pc0-pcmin)*n/max_gen;%%计算交叉概率
    pv=pv0-(pv0-pvmin)*n/max_gen;%%计算变异概率
    fit_value=a.*path_value+b.*yaw_value+c.*pitch_value;%%适应度
    child_path=selection(fit_value,path);%%选择
    child_path=cross(child_path,pc);%%交叉
    child_path=variation(child_path,pv,map);%%变异
    
    %%%%重新计算各数据
    [path_value_true_new,~]=cal_path_value(child_path,map);%%计算路径长度
    %%模拟退火算法
    for m=1:1:NP
        if(path_value_true_new(m)<path_value_true(m))
            p_anneal=1;%%退火概率为1
        else
            p_anneal=exp((path_value_true(m)-path_value_true_new(m))/t0);
        end
        if rand(1)<=p_anneal
            path(m,:,:)=child_path(m,:,:);
        end
    end
    [path_value_true,path_value]=cal_path_value(path,map);%%计算路径长度
    [yaw_value_true,yaw_value]=cal_yaw_value(path);%%偏航角情况
    [pitch_value_true,pitch_value]=cal_pitch_value(path,map);%%俯仰角情况
    t0=t0*r;%%更新温度
    mean_path_value_true(1,n)=mean(path_value_true);%%计算平均路径长度
    mean_yaw_value_true(1,n)=mean(yaw_value_true);
    mean_pitch_value_true(1,n)=mean(pitch_value_true);
    min_path_value_true(1,n)=min(path_value_true);%%计算最小路径长度
    min_yaw_value_true(1,n)=min(yaw_value_true);
    min_pitch_value_true(1,n)=min(pitch_value_true);
end

%%输出部分

[~,pos]=find(fit_value==max(fit_value));
pos=pos(1);%%排除最后路径一摸一样出现多个最优点问题
fprintf('--------------------------------------\n');
fprintf('最优距离的路径值为：%.2f米\n偏航值为：%.2f\n俯仰值为：%.2f\n适应度：%.2f\n',path_value_true(pos),yaw_value_true(pos),pitch_value_true(pos),fit_value(pos));
fprintf('--------------------------------------\n');

% %画图
% % 收敛曲线
figure;
plot(1:max_gen,mean_path_value_true(1,:),'r-');
hold on;
plot(1:max_gen,min_path_value_true(1,:),'b-');
title('路径值');
legend('平均值','最小值');
%偏航角
figure;
plot(1:max_gen,mean_yaw_value_true(1,:),'r-');
hold on;
plot(1:max_gen,min_yaw_value_true(1,:),'b-');
title('偏航值');
legend('平均值','最小值');
%俯仰角
figure
plot(1:max_gen,mean_pitch_value_true(1,:),'r-');
hold on;
plot(1:max_gen,min_pitch_value_true(1,:),'b-');
title('俯仰值');
legend('平均值','最小值');
%%路径图
figure;
mesh(map.X,map.Y,map.Z');
axis([1 301 1 301 hmin hmax*1.25]);
colormap jet;
xlabel('x/38.2m');
ylabel('y/38.2m');
zlabel('z/m');
set(gca,'Position',[0.07 0.08 0.9 0.9]);
hold on;
%  for k=1:1:NP %%绘制所有路径图像
% plot3(path(k,:,1),path(k,:,2),path(k,:,3),'ro-','LineWidth',2);
% end
%绘制最优路径图像
plot3(path(pos,:,1),path(pos,:,2),path(pos,:,3),'ro-','LineWidth',2);
toc%%计时结束