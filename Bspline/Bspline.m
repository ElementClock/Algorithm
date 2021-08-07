
% 绘制三种类型的B样条曲线，需要前面所给的所有.m文件
clc;
clear all;
% load out                        %加载规划点
% %控制顶点
% P=Xplot2(:,1:3);            %提取1到3列的数据
% P=P';                           %转置是为了方便运算
%控制顶点个数
for ii=1:10
P=[
    0	100	100	2000
0	1100+100*ii	1300+100*ii	2000
0	30	40	60    
    ];
n = length(P)-1;
%B样条曲线的阶数
k =3 ;
NodeVector = U_quasi_uniform(n, k);     %准均匀B样条的节点矢量
Bspline_point=DrawSpline(n, k, P, NodeVector);        %绘图
Xplot2=Bspline_point';
axis('equal'); %调整各坐标轴，使单位长度相同
Xplot2(:,4)=6;
Xplot2(:,5)=0;
Xplot2(:,6)=0.01;
eval(['save("fw_' num2str(ii) '.mat","Xplot2");'])
end
