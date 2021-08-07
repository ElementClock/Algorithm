%函数将插值点等距扩充两倍
clc,clear;
load 'Bspline_point.mat'
m=1;
for i=1:200

    Xplot(m,1:3)= Xplot2(i,1:3);
    Xplot(m+1,1:3)= Xplot2(i,1:3);
m=m+2;
end
Xplot2=Xplot;

x=timeseries(Xplot2(1:400,1));
y=timeseries(Xplot2(1:400,2));
z=timeseries(-Xplot2(1:400,3));
save ('Bspline_point.mat','Xplot2');