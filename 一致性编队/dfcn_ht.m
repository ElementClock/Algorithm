function y = dfcn_ht(u)
t = u;
r = 10;
d = 5;
omega = 0.1;
g = zeros(1,5);
dh_xX = zeros(1,5);
dh_vX = zeros(1,5);
dh_xY = zeros(1,5);
dh_vY = zeros(1,5);
for i = 1:5
   %% Application1
%      g(i) = sign(sin(omega*t/2+pi*(i-1)/5));
%     dh_xX(i) = omega*r*cos(omega*t + (2*pi*(i - 1))/5 - 1)*cos((omega*t)/2 + (pi*(i - 1))/5)*dirac(sin((omega*t)/2 + (pi*(i - 1))/5)) - omega*r*sign(sin((omega*t)/2 + (pi*(i - 1))/5))*sin(omega*t + (2*pi*(i - 1))/5 - 1);%期望编队位置X
%     dh_vX(i) = - omega^2*r*sign(sin((omega*t)/2 + (pi*(i - 1))/5))*cos(omega*t + (2*pi*(i - 1))/5) - omega^2*r*cos((omega*t)/2 + (pi*(i - 1))/5)*sin(omega*t + (2*pi*(i - 1))/5)*dirac(sin((omega*t)/2 + (pi*(i - 1))/5));%期望编队速度X导数
%     dh_xY(i) = omega*r*cos(omega*t + (2*pi*(i - 1))/5);%期望编队位置Y
%     dh_vY(i)= -omega^2*r*sin(omega*t + (2*pi*(i - 1))/5);%期望编队速度Y
    %% Application2
    dh_xX(i) = r*omega*cos((omega*t+2*pi*(i-1)/5));%期望编队位置X
    dh_vX(i) = -r*omega^2*sin(omega*t+2*pi*(i-1)/5);%期望编队速度X
    dh_xY(i) = -r*omega*sin(omega*t+2*pi*(i-1)/5);%期望编队位置Y
    dh_vY(i)= -r*omega^2*cos(omega*t+2*pi*(i-1)/5);%期望编队速度Y
    %% Application 3
%     dh_xX(i) = r*omega*cos(omega*t);%期望编队位置X
%     dh_vX(i) = -r*omega^2*sin(omega*t);%期望编队速度X
%     dh_xY(i) = 2*r*omega*cos(2*omega*t);%期望编队位置Y
%     dh_vY(i)=  -4*r*omega^2*sin(2*omega*t);%期望编队速度Y
end
y11 = [dh_vX(:,1) dh_vY(:,1)];
y12 = [dh_vX(:,2) dh_vY(:,2)];
y13 = [dh_vX(:,3) dh_vY(:,3)];
y14 = [dh_vX(:,4) dh_vY(:,4)];
y15 = [dh_vX(:,5) dh_vY(:,5)];

y21 = [dh_xX(:,1) dh_xY(:,1)];
y22 = [dh_xX(:,2) dh_xY(:,2)];
y23 = [dh_xX(:,3) dh_xY(:,3)];
y24 = [dh_xX(:,4) dh_xY(:,4)];
y25 = [dh_xX(:,5) dh_xY(:,5)];
y1 = [y11 y12  y13  y14  y15];
y2 = [y21 y22  y23  y24  y25];
y = y1;