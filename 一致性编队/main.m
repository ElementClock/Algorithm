clear;clc;close all
W = [0 0 0 0 1;1 0 0 0 0;0 1 0 0 0;0 0 1 0 0;0 0 0 1 0];%图G的邻接矩阵
D = eye(5);%入度矩阵，设计连接权重都为1
L = D-W;%拉普拉斯算子矩阵
[V,E] = eig(L);%获取特征向量、特征值
V(:,1) = ones(5,1);
VV = inv(V);%求逆
B1 = [1 0]';
B2 = [0 1]';
B3 = eye(2);%identity matrix
%% 应用
k1 = [-0.25 0];
k2 = [1.1299 2.3162];
K1 = kron(B3,k1);%K1用来设计编队中心的运动模式
K2 = kron(B3,k2);%使所有UAV达到要求编队
FormationCenter = eig(kron(B3,B2)*K1+kron(B3,B1*B2'));%编队中心
%% 初始状态
theta10 = 1*[rand(1) rand(1) rand(1) rand(1)]';%初始x位置,x速度,y位置，y速度
theta20 = 2*[rand(1) rand(1) rand(1) rand(1)]';
theta30 = 3*[rand(1) rand(1) rand(1) rand(1)]';
theta40 = 4*[rand(1) rand(1) rand(1) rand(1)]';
theta50 = 5*[rand(1) rand(1) rand(1) rand(1)]';
%%
theta0 = [theta10;theta20;theta30;theta40;theta50];
A = kron(D,kron(B3,(B2*k1+B1*B2')))-kron(L,kron(B3,B2*k2));
B_h = kron(D,kron(B3,B2*k1))-kron(L,kron(B3,B2*k2));
B_hv = kron(D,kron(B3,B2));
VV(1,:) = [0.2 0.2 0.2 0.2 0.2];
%%
A_xi = kron(B3,B2*k1+B1*B2');
B_xi = kron(VV(1,:),kron(B3,B1));
ht0 = [2.88787489116887,0.957393224401324,9.57393224401324,-0.288787489116887,9.99775306623696,0.0211975532903053,0.211975532903053,-0.999775306623696,3.29107631489405,-0.944292415989578,-9.44292415989578,-0.329107631489405,-7.96375604406268,-0.604802361690620,-6.04802361690620,0.796375604406268,-8.21294822823719,0.570503999988568,5.70503999988568,0.821294822823719]';
xi0 = kron(VV(1,:),kron(B3,B3))*(theta0-ht0);
sim consistency;
plotResult;