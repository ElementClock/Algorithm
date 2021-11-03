%%Dong2015IEEE作图\
clc
close all
m=500;
figure(1)%多个智能体的运动轨迹
hold on
box on
plot(theta(length(tout),1),theta(length(tout),3),'ks')%终点
plot(theta(length(tout),5),theta(length(tout),7),'bd')%终点
plot(theta(length(tout),9),theta(length(tout),11),'rv')%终点
plot(theta(length(tout),13),theta(length(tout),15),'g^')%终点
plot(theta(length(tout),17),theta(length(tout),19),'m<')%终点
plot(xi(length(tout),1),xi(length(tout),3),'cp')%终点
legend('UAV1','UAV2','UAV3','UAV4','UAV5')
plot(theta(1,1),theta(1,3),'ko')%初始点
plot(theta(1,5),theta(1,7),'bo')%初始点
plot(theta(1,9),theta(1,11),'ro')%初始点
plot(theta(1,13),theta(1,15),'go')%初始点
plot(theta(1,17),theta(1,19),'mo')%初始点
plot(xi(1,1),xi(1,3),'co')

plot(theta(:,1),theta(:,3),'k-')
plot(theta(:,5),theta(:,7),'b-')
plot(theta(:,9),theta(:,11),'r-')
plot(theta(:,13),theta(:,15),'g-')
plot(theta(:,17),theta(:,19),'m-')
plot(xi(:,1),xi(:,3),'c-')


plot([theta(m,1),theta(m,5)],[theta(m,3),theta(m,7)],'-.k')
plot([theta(m,5),theta(m,9)],[theta(m,7),theta(m,11)],'-.k')
plot([theta(m,9),theta(m,13)],[theta(m,11),theta(m,15)],'-.k')
plot([theta(m,13),theta(m,17)],[theta(m,15),theta(m,19)],'-.k')
plot([theta(m,17),theta(m,1)],[theta(m,19),theta(m,3)],'-.k')

figure(2)%实际模型速度
hold on
box on
plot(theta(length(tout),2),theta(length(tout),4),'ks')%终点
plot(theta(length(tout),6),theta(length(tout),8),'bd')%终点
plot(theta(length(tout),10),theta(length(tout),12),'rv')%终点
plot(theta(length(tout),14),theta(length(tout),16),'g^')%终点
plot(theta(length(tout),18),theta(length(tout),20),'m<')%终点
plot(xi(length(tout),2),xi(length(tout),4),'cp')%终点
legend('UAV1','UAV2','UAV3','UAV4','UAV5','c(t)')
plot(theta(1,2),theta(1,4),'ko')%初始点
plot(theta(1,6),theta(1,8),'bo')%初始点
plot(theta(1,10),theta(1,12),'ro')%初始点
plot(theta(1,14),theta(1,16),'go')%初始点
plot(theta(1,18),theta(1,20),'mo')%初始点
plot(xi(1,2),xi(1,4),'co')

plot(theta(:,2),theta(:,4),'k-')
plot(theta(:,6),theta(:,8),'b-')
plot(theta(:,10),theta(:,12),'r-')
plot(theta(:,14),theta(:,16),'g-')
plot(theta(:,18),theta(:,20),'m-')
plot(xi(:,2),xi(:,4),'c-')


figure(3)%期望编队的运动轨迹
hold on
box on

plot(ht(length(tout),1),ht(length(tout),3),'ks')%终点
plot(ht(length(tout),5),ht(length(tout),7),'bd')%终点
plot(ht(length(tout),9),ht(length(tout),11),'rv')%终点
plot(ht(length(tout),13),ht(length(tout),15),'g^')%终点
plot(ht(length(tout),17),ht(length(tout),19),'m<')%终点
legend('UAV1','UAV2','UAV3','UAV4','UAV5')
plot(ht(1,1),ht(1,3),'ko')%初始点
plot(ht(1,5),ht(1,7),'bo')%初始点
plot(ht(1,9),ht(1,11),'ro')%初始点
plot(ht(1,13),ht(1,15),'go')%初始点
plot(ht(1,17),ht(1,19),'mo')%初始点


plot(ht(:,1),ht(:,3),'k-')
plot(ht(:,5),ht(:,7),'b-')
plot(ht(:,9),ht(:,11),'r-')
plot(ht(:,13),ht(:,15),'g-')
plot(ht(:,17),ht(:,19),'m-')

plot([ht(m,1),ht(m,5)],[ht(m,3),ht(m,7)],'-.k')
plot([ht(m,5),ht(m,9)],[ht(m,7),ht(m,11)],'-.k')
plot([ht(m,9),ht(m,13)],[ht(m,11),ht(m,15)],'-.k')
plot([ht(m,13),ht(m,17)],[ht(m,15),ht(m,19)],'-.k')
plot([ht(m,17),ht(m,1)],[ht(m,19),ht(m,3)],'-.k')
legend('UAV1','UAV2','UAV3','UAV4','UAV5')

figure(4)%编队参考函数速度
hold on
box on
plot(ht(length(tout),2),ht(length(tout),4),'ks')%终点
plot(ht(length(tout),6),ht(length(tout),8),'bd')%终点
plot(ht(length(tout),10),ht(length(tout),12),'rv')%终点
plot(ht(length(tout),14),ht(length(tout),16),'g^')%终点
plot(ht(length(tout),18),ht(length(tout),20),'m<')%终点
legend('UAV1','UAV2','UAV3','UAV4','UAV5','c(t)')
plot(ht(1,2),ht(1,4),'ko')%初始点
plot(ht(1,6),ht(1,8),'bo')%初始点
plot(ht(1,10),ht(1,12),'ro')%初始点
plot(ht(1,14),ht(1,16),'go')%初始点
plot(ht(1,18),ht(1,20),'mo')%初始点

plot(ht(:,2),ht(:,4),'k-')
plot(ht(:,6),ht(:,8),'b-')
plot(ht(:,10),ht(:,12),'r-')
plot(ht(:,14),ht(:,16),'g-')
plot(ht(:,18),ht(:,20),'m-')
