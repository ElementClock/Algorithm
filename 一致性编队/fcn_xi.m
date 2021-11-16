function y = fcn_xi(u)
t = u;
r = 10;
d = 5;
omega = 0.1;
g = zeros(1,5);
h_xX = zeros(1,5);
h_vX = zeros(1,5);
h_xY = zeros(1,5);
h_vY = zeros(1,5);
dh_xX = zeros(1,5);
dh_vX = zeros(1,5);
dh_xY = zeros(1,5);
dh_vY = zeros(1,5);

for i = 1:5
    h_xX(i) = r*sin(omega*t+2*pi*(i-1)/5);%�������λ��X
    h_vX(i) = r*omega*cos(omega*t+2*pi*(i-1)/5);%��������ٶ�X
    h_xY(i) = r*cos(omega*t+2*pi*(i-1)/5);%�������λ��Y
    h_vY(i)= -r*omega*sin(omega*t+2*pi*(i-1)/5);%��������ٶ�Y
    dh_xX(i) = r*omega*cos((omega*t+2*pi*(i-1)/5));%�������λ��X
    dh_vX(i) = -r*omega^2*sin(omega*t+2*pi*(i-1)/5);%��������ٶ�X
    dh_xY(i) = -r*omega*sin(omega*t+2*pi*(i-1)/5);%�������λ��Y
    dh_vY(i)= -r*omega^2*cos(omega*t+2*pi*(i-1)/5);%��������ٶ�Y
end
y11 = [h_vX(:,1) h_vY(:,1)];
y12 = [h_vX(:,2) h_vY(:,2)];
y13 = [h_vX(:,3) h_vY(:,3)];
y14 = [h_vX(:,4) h_vY(:,4)];
y15 = [h_vX(:,5) h_vY(:,5)];

y21 = [dh_xX(:,1) dh_xY(:,1)];
y22 = [dh_xX(:,2) dh_xY(:,2)];
y23 = [dh_xX(:,3) dh_xY(:,3)];
y24 = [dh_xX(:,4) dh_xY(:,4)];
y25 = [dh_xX(:,5) dh_xY(:,5)];
y1 = [y11-y21 y12-y22  y13-y23  y14-y24  y15-y25];
y = y1;
