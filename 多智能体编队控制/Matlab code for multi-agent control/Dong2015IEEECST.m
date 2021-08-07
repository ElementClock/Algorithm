%% Xiwang Dong 2015年发表在IEEE Transactions CST上的论文
%论文题目是：Time-Varying Formation Control for Unmanned Aerial Vehicles:Theories and Applications
clear
clc
close all

W = [0 0 0 0 1;1 0 0 0 0;0 1 0 0 0;0 0 1 0 0;0 0 0 1 0];%图G的邻接矩阵
D = eye(5);%入度矩阵
L = D-W;%Laplacian matrix
[V E] = eig(L);
V(:,1) = ones(5,1);
VV = inv(V);
B1 = [1 0]';
B2 = [0 1]';
B3 = eye(2);%identity matrix
%% application 1 and 3
% k1 = [-2 -1.2];
% k2 = [0.3416 0.7330];
%% application 2
k1 = [-0.25 0];
k2 = [1.1299 2.3162];
K1 = kron(B3,k1);%K1用来设计编队中心的运动模式
K2 = kron(B3,k2);%使所有UAV达到要          求编队
FormationCenter = eig(kron(B3,B2)*K1+kron(B3,B1*B2'));%编队中心
%% intitial states for application 1
% theta10 = [-0.16 0.03 -0.07 -0.01]';%UAV1的初始条件(位置X，速度X，位置Y，速度Y)application1
% theta20 = [-4.92 -0.08 6.38 -0.04]';%UAV2的初始条件application 1
% theta30 = [-12.37 -0.26 4.08 -0.03]';%UAV3的初始条件application 1
% theta40 = [-12.73 0.03 -4.56 -0.04]';%UAV4的初始条件application 1
% theta50 = [-4.63 -0.05 -6.9 0.02]';%UAV5的初始条件application 1
%% initial states for application 3
% theta10 = [5.19,0,-0.04,0]';%application3
% theta20 = [1.89,-0.12,4.38,-0.11]';% application3
% theta30 = [-3.65,-0.29,2.71,-0.05]';%application3
% theta40 = [-3.90,-0.18,-3.6,0.08]';%application3
% theta50 = [2,-0.02,-5.13,0.02]';%application3
%% initial states for application 2
theta10 = 1*[rand(1) rand(1) rand(1) rand(1)]';%application2
theta20 = 2*[rand(1) rand(1) rand(1) rand(1)]';% application2
theta30 = 3*[rand(1) rand(1) rand(1) rand(1)]';%application2
theta40 = 4*[rand(1) rand(1) rand(1) rand(1)]';%application2
theta50 = 5*[rand(1) rand(1) rand(1) rand(1)]';%application2
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%% 求导数
% syms omega r i t
% g = sign(sin(omega*t/2+pi*(i-1)/5));
% h_xX =  r*cos((omega*t+2*pi*(i-1)/5)-1)*g;
% h_vX = -r*omega*sin(omega*t+2*pi*(i-1)/5)*g;
% h_xY = r*sin(omega*t+2*pi*(i-1)/5);
% h_vY = r*omega*cos(omega*t+2*pi*(i-1)/5);
% 
% dh_xX = diff(h_xX,t);
% dh_vX = diff(h_vX,t);
% dh_xY = diff(h_xY,t);
% dh_vY = diff(h_vY,t);
%%


%系统的微分方程为dtheta=A*theta(t)-B_h*h(t)+B_hv*derivativeh_v(t)
% xi0 = kron(VV(1,:),kron(B3,B3))*(theta0-ht0);
% zeta0 = kron(VV(2:5,:),kron(B3,B3))*(theta0-ht0);
% zeta0 = real(zeta0);
% zeta_A = kron(eye(4),kron(B3,(B2*k1+B1*B2')))-real(kron(E(2:5,2:5),kron(B3,B2*k2)));
% %% 求解h(t)和dh_v
% r = 7;
% omega = 0.214;
% for i = 1:5
%          %% Application1
%          t = 0.01:0.1:200;
%          g(:,i) = sign(sin(omega*t/2+pi*(i-1)/5));
%          h_xX(:,i) = r*cos((omega*t+2*pi*(i-1)/5)-1).*g(i);%期望编队位置X
%          h_vX(:,i) = -r*omega*sin(omega*t+2*pi*(i-1)/5)*g(i);%期望编队速度X
%          h_xY(:,i) = r*sin(omega*t+2*pi*(i-1)/5);%期望编队位置Y
%          h_vY(:,i) = r*omega*cos(omega*t+2*pi*(i-1)/5);%期望编队速度Y
%          dh_vX(:,i) = -r*omega^2*cos(omega*t+2*pi*(i-1)/5)*g(i);%期望编队速度X导数
%          dh_vY(:,i) = -r*omega^2*sin(omega*t+2*pi*(i-1)/5);%期望编队速度Y
%         %% Application2
%     %     g(i) = sign(sin(omega*t/2+pi*(i-1)/5));
%     %     h_xX(i) = r*sin((omega*t+2*pi*(i-1)/5));%期望编队位置X
%     %     h_vX(i) = r*omega*cos(omega*t+2*pi*(i-1)/5);%期望编队速度X
%     %     h_xY(i) = r*cos(omega*t+2*pi*(i-1)/5);%期望编队位置Y
%     %     h_vY(i)= -r*omega*sin(omega*t+2*pi*(i-1)/5);%期望编队速度Y
% end
% ht = [h_xX h_vX h_xY h_vY];
% dhv = [dh_vX  dh_vY];
