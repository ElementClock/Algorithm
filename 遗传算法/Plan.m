clear;
clc;
close all;
tic;                                           %计时开始
%% 加载地图
dem=load('taiwan_map.mat');   %截取是台湾地区数据 900平方公里
map.Z=dem.map.Z;
map.X=dem.map.X;
map.Y=dem.map.Y;
map.gap=30;                            %相邻间隔
hmin=min(min(map.Z));            %用来画图，如果只用一个min，得出的结果是每一列的最小值，下同
hmax=max(max(map.Z));
%% 加载威胁
%此处将威胁构造成地图上的障碍
%都是基于30米高程下的数据
%       X对应于z的列，Y对应于z的行
Threat.point1=[200 500];
Threat.length1=400;
Threat.width1=20;%此处的10实际为10*30为300m
Threat.tall1=400;
map=rectangleThreat(Threat.point1,Threat.length1,Threat.width1,Threat.tall1,map);
map=rectangleThreat([500 450],20,200,400,map);
Threat.point2=[200 300];
Threat.radius2=10;                          %此处的100实际为100*30为3000m
Threat.tall2=200;
map=roundThreat(Threat.point2,Threat.radius2,Threat.tall2,map);
map=roundThreat([500 700],20,500,map);

% save(['C:\Users\Alpha\Desktop\GitHub\mav\platform_code\map.mat'],'map');
% %飞行航迹威胁   编队控制
% num=num-1;
% if num>0
%     for num=1:num
% eval(['load fw_' num2str(num) '.mat']);
% map=flyThreat(Xplot2,map);
%     end
% end

% %调试代码
% figure;
% mesh(map.X,map.Y,map.Z');
% axis('equal');
% colormap jet;
% xlabel('x/m');
% ylabel('y/m');
% zlabel('z/m');
% %调试代码



%% 初始点部分
Departure=[700 10];
Destination=[500 1000];                       %这两个是接口,此处的坐标为在30m每格高程图下的坐标，非实际的1m的坐标
start_x=Departure(1);
start_y=Departure(2);
end_x=Destination(1);
end_y=Destination(2);
p_start=[start_x,start_y,map.Z(start_x,start_y)+50];      %起始点坐标
p_end=[end_x,end_y,map.Z(end_x,end_y)+50];

map.x_Interval=length(map.X);



%% 模拟退火算法部分参数
t0=9*10^3;                               %初始温度
t=10;                                        %结束温度
r=0.95;                                     %降温系数t0=r*t0

%% 遗传算法部分参数
NP=500;                                  %种群数量
max_gen=ceil(log(t/t0)/log(r));    %种群进化次数 %Y = ceil(X)将 的每个元素四舍五入X到最接近的大于或等于该元素的整数。
pathnum=50;                             %路径点个数
pc0=0.95;                                    %交叉概率
pv0=0.95;                                    %变异概率
pcmin=0.1;
pvmin=0.02;
a=0.9;                                       %路径长度比重
b=0.05;                                     %偏航角比重
c=0.05;                                      %俯仰角比重


%% 产生初始种群
path=zeros(NP,pathnum,3);       %1是x坐标，2是y坐标，3是z坐标
for i=1:NP
    
    for k=1:3                            %赋值初始起点和终点
        path(i,1,k)=p_start(k);
        path(i,pathnum,k)=p_end(k);
    end
    
%     x0=rand(1);                              %随机范围0~0.99避免取值0，0.25，0.5，0.75，1.0导致混沌失效
    y0=rand(1);
    
    %种群初始化
    for j=2:1:pathnum-1               %出发点和目的点不动
        path(i,j,1)=path(i,1,1)+(j-1)*floor((path(i,pathnum,1)-path(i,1,1))/pathnum);     %固定x轴的间距
        y1=4*y0*(1-y0);
        path(i,j,2)=round(1+y1*(map.x_Interval-1));
        y0=y1;
        path(i,j,3)=map.Z(path(i,j,1),path(i,j,2))+randi([50,250],1,1);
    end
    
end


% for      nnp=1:NP                    %调试代码：显示初始化种群分布
%     set(gca,'Position',[0.07 0.08 0.9 0.9]);
%     hold on;
% plot3(path(nnp,:,1)*30,path(nnp,:,2)*30,path(nnp,:,3),'ro-','LineWidth',2)
% end
% mesh(map.X,map.Y,map.Z');
% axis('equal');



%% 初始化各类函数
mean_path_value_true=zeros(1,max_gen);                             %初始化平均路径长度
min_path_value_true=zeros(1,max_gen);                                %初始化最短路径长度
mean_yaw_value_true=zeros(1,max_gen);                              %初始化平均偏航角真值
min_yaw_value_true=zeros(1,max_gen);                                 %初始化最小偏航角真值
mean_pitch_value_true=zeros(1,max_gen);                             %初始化平均俯仰角真值
min_pitch_value_true=zeros(1,max_gen);                                %初始化最小俯仰角真值

%% 计算初始适应度
[path_value_true,path_value]=cal_path_value(path,map);        %路径值
[yaw_value_true,yaw_value]=cal_yaw_value(path);                   %偏航角情况
[pitch_value_true,pitch_value]=cal_pitch_value(path,map);      %俯仰角情况


%% 选择、交叉、变异过程
for n=1:1:max_gen
    fprintf('第%d次进化，已完成%.1f%%\n',n,n/max_gen*100);
    pc=pc0-(pc0-pcmin)*n/max_gen;                                     %计算交叉概率
    pv=pv0-(pv0-pvmin)*n/max_gen;                                     %计算变异概率
    fit_value=a.*path_value+b.*yaw_value+c.*pitch_value;      %适应度
    child_path=selection(fit_value,path);                                 %选择
    child_path=cross(child_path,pc);                                       %交叉
    child_path=variation(child_path,pv,map);                          %变异
    %重新计算各数据
    [path_value_true_new,~]=cal_path_value(child_path,map);      %计算路径长度
    %模拟退火算法
    for m=1:1:NP
        if(path_value_true_new(m)<path_value_true(m))
            p_anneal=1;                                                            %退火概率为1
        else
            p_anneal=exp((path_value_true(m)-path_value_true_new(m))/t0);
        end
        if rand(1)<=p_anneal
            path(m,:,:)=child_path(m,:,:);
        end
    end
    [path_value_true,path_value]=cal_path_value(path,map);                                    %计算路径长度
    [yaw_value_true,yaw_value]=cal_yaw_value(path);                                              %偏航角情况
    [pitch_value_true,pitch_value]=cal_pitch_value(path,map);                               %俯仰角情况
    t0=t0*r;                                                                                                        %更新温度
    mean_path_value_true(1,n)=mean(path_value_true);                                    %计算平均路径长度
    mean_yaw_value_true(1,n)=mean(yaw_value_true);
    mean_pitch_value_true(1,n)=mean(pitch_value_true);
    min_path_value_true(1,n)=min(path_value_true);                                           %计算最小路径长度
    min_yaw_value_true(1,n)=min(yaw_value_true);
    min_pitch_value_true(1,n)=min(pitch_value_true);
end

%% 输出部分
[~,pos]=find(fit_value==max(fit_value));
pos=pos(1);                                                                               %排除最后路径一摸一样出现多个最优点问题
fprintf('--------------------------------------\n');
fprintf('最优距离的路径值为：%.2f米\n偏航值为：%.2f\n俯仰值为：%.2f\n适应度：%.2f\n',path_value_true(pos),yaw_value_true(pos),pitch_value_true(pos),fit_value(pos));
fprintf('--------------------------------------\n');

%% 画图
%绘制最优路径图像
figure;
mesh(map.X,map.Y,map.Z');
axis('equal');
colormap jet;
xlabel('x/m');
ylabel('y/m');
zlabel('z/m');
set(gca,'Position',[0.07 0.08 0.9 0.9]);
hold on;
plot3(path(pos,:,1)*map.gap,path(pos,:,2)*map.gap,path(pos,:,3),'ro-','LineWidth',2);                   %乘以间隔是高程图的精细度
toc
%计时结束

% %% 将数据存储至mat
% v=ones(1,pathnum)*1;                                      %这里和B样条重复了，都给固定翼其余几个值赋值了，不过覆盖了，无所谓，多旋翼不需要，到时候再改
% alpha=zeros(1,pathnum);
% beta=zeros(1,pathnum);
% Xplot2=[path(pos,:,1)*map.gap;
%              path(pos,:,2)*map.gap;
%              path(pos,:,3);
%            v;
%            alpha;
%            beta;
%   ];
% Xplot2=Xplot2';
% pathname='C:\Users\Alpha\Desktop\GitHub\mav\platform_code\Bspline\';
% filename='out';
% save([pathname,filename],'Xplot2');
%


%%
% for k=1:1:NP %%绘制所有路径图像
% plot3(path(k,:,1),path(k,:,2),path(k,:,3),'ro-','LineWidth',2);
% end

%收敛曲线
% figure;
% plot(1:max_gen,mean_path_value_true(1,:),'r-');
% hold on;
% plot(1:max_gen,min_path_value_true(1,:),'b-');
% title('路径值');
% legend('平均值','最小值');
% %偏航角
% figure;
% plot(1:max_gen,mean_yaw_value_true(1,:),'r-');
% hold on;
% plot(1:max_gen,min_yaw_value_true(1,:),'b-');
% title('偏航值');
% legend('平均值','最小值');
% %俯仰角
% figure
% plot(1:max_gen,mean_pitch_value_true(1,:),'r-');
% hold on;
% plot(1:max_gen,min_pitch_value_true(1,:),'b-');
% title('俯仰值');
% legend('平均值','最小值');

