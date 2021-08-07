function y = fcn_ht(u)
t = u;
r = 10;
d = 5;
omega = 0.1;
g = zeros(1,5);
h_xX = zeros(1,5);
h_vX = zeros(1,5);
h_xY = zeros(1,5);
h_vY = zeros(1,5);
for i = 1:5
         %% Application1
%          g(i) = sign(sin(omega*t/2+pi*(i-1)/5));
%          h_xX(i) = r*cos((omega*t+2*pi*(i-1)/5)-1)*g(i);%期望编队位置X
%          h_vX(i) = -r*omega*sin(omega*t+2*pi*(i-1)/5)*g(i);%期望编队速度X
%          h_xY(i) = r*sin(omega*t+2*pi*(i-1)/5);%期望编队位置Y
%          h_vY(i)= r*omega*cos(omega*t+2*pi*(i-1)/5);%期望编队速度Y
         
        %% Application2
        h_xX(i) = r*sin(omega*t+2*pi*(i-1)/5);%期望编队位置X
        h_vX(i) = r*omega*cos(omega*t+2*pi*(i-1)/5);%期望编队速度X
        h_xY(i) = r*cos(omega*t+2*pi*(i-1)/5);%期望编队位置Y
        h_vY(i)= -r*omega*sin(omega*t+2*pi*(i-1)/5);%期望编队速度Y
%% Application 3
%           h_xX(i) = r*sin(omega*t)+d*cos(2*pi*(i-1)/5);%期望编队位置X
%           h_vX(i) = r*omega*cos(omega*t);%期望编队速度X
%           h_xY(i) = r*sin(2*omega*t)+d*sin(2*pi*(i-1)/5);%期望编队位置Y
%           h_vY(i)=  2*r*omega*cos(2*omega*t);%期望编队速度Y
end
y11 = [h_xX(:,1) h_vX(:,1) h_xY(:,1) h_vY(:,1)];
y12 = [h_xX(:,2) h_vX(:,2) h_xY(:,2) h_vY(:,2)];
y13 = [h_xX(:,3) h_vX(:,3) h_xY(:,3) h_vY(:,3)];
y14 = [h_xX(:,4) h_vX(:,4) h_xY(:,4) h_vY(:,4)];
y15 = [h_xX(:,5) h_vX(:,5) h_xY(:,5) h_vY(:,5)];
y = [y11 y12 y13  y14 y15];

%% 定积分求解
% a1 = 14.79;
% b1 = -6.018;
% c1 = 24.62;
% a2 = 18550;
% b2 = 914.5;
% c2 = 337.1;
% syms x
% f = -a1*exp(-((x-b1)/c1)^2)-a2*exp(-((x-b2)/c2)^2);
% g1 = double(int(f,x,0,inf))