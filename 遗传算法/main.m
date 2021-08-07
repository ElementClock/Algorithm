%%������
clear;
clc;
close all;
tic;
%%�����ͼ,��ͼxy���ڼ��Ϊ38.2m
dem=load('DEM.mat');
map.Z=dem.DEM(401:701,401:701);%%ԭ 4 7
map.X=1:301;
map.Y=1:301;
map.gap=38.2;%%���ڼ��
hmin=min(min(map.Z));%%������ͼ                    ���ֻ��һ��min���ó��Ľ����ÿһ�е���Сֵ����ͬ
hmax=max(max(map.Z));


%%ģ���˻��㷨���ֲ���
t0=9*10^3;%%��ʼ�¶�
t=10;%%�����¶�
r=0.95;%%����ϵ��t0=r*t0

%%�Ŵ��㷨���ֲ���
NP=5000;%%��Ⱥ����
max_gen=ceil(log(t/t0)/log(r));    %��Ⱥ��������                          %Y = ceil(X)�� ��ÿ��Ԫ����������X����ӽ��Ĵ��ڻ���ڸ�Ԫ�ص�������
pathnum=60;%%·�������
%%�ı����
pc0=0.7;%%�������
pv0=0.1;%%�������
pcmin=0.1;
pvmin=0.02;
a=0.5;%%·�����ȱ���
b=0.25;%%ƫ���Ǳ���
c=0.25;%%�����Ǳ���
%%��ʼ�㲿��
p_start=[1,1,map.Z(1,1)+50];%%��ʼ�����꣨1��1��Z��
p_end=[301,301,map.Z(size(map.X,2),size(map.X,2))+50];

%%path����DNA
%%������ʼ��Ⱥ
path=zeros(NP,pathnum,3);%%1��x���꣬2��y���꣬3��z����
for i=1:1:NP
    for k=1:1:3 %%��ʼ�����յ�
        path(i,1,k)=p_start(k);
        path(i,pathnum,k)=p_end(k);
    end
    x0=rand(1);
    
    for j=2:1:pathnum-1
        path(i,j,1)=1+(j-1)*floor(300/pathnum);
        %logistic����
        x1=4*x0*(1-x0);
        path(i,j,2)=round(1+x1*(301-1));
        x0=x1;
        path(i,j,3)=map.Z(path(i,j,1),path(i,j,2))+randi([50,250],1,1);
    end
end

%��ʼ�����ຯ��
mean_path_value_true=zeros(1,max_gen);%%��ʼ��ƽ��·������
min_path_value_true=zeros(1,max_gen);%%��ʼ�����·������
mean_yaw_value_true=zeros(1,max_gen);%%��ʼ��ƽ��ƫ������ֵ
min_yaw_value_true=zeros(1,max_gen);%%��ʼ����Сƫ������ֵ
mean_pitch_value_true=zeros(1,max_gen);%%��ʼ��ƽ����������ֵ
min_pitch_value_true=zeros(1,max_gen);%%��ʼ����С��������ֵ

%%�����ʼ��Ӧ��
[path_value_true,path_value]=cal_path_value(path,map);%%·��ֵ
[yaw_value_true,yaw_value]=cal_yaw_value(path);%%ƫ�������
[pitch_value_true,pitch_value]=cal_pitch_value(path,map);%%���������


%%ѡ�񡢽��桢�������
for n=1:1:max_gen
    fprintf('��%d�ν����������%.1f%%\n',n,n/max_gen*100);
    pc=pc0-(pc0-pcmin)*n/max_gen;%%���㽻�����
    pv=pv0-(pv0-pvmin)*n/max_gen;%%����������
    fit_value=a.*path_value+b.*yaw_value+c.*pitch_value;%%��Ӧ��
    child_path=selection(fit_value,path);%%ѡ��
    child_path=cross(child_path,pc);%%����
    child_path=variation(child_path,pv,map);%%����
    
    %%%%���¼��������
    [path_value_true_new,~]=cal_path_value(child_path,map);%%����·������
    %%ģ���˻��㷨
    for m=1:1:NP
        if(path_value_true_new(m)<path_value_true(m))
            p_anneal=1;%%�˻����Ϊ1
        else
            p_anneal=exp((path_value_true(m)-path_value_true_new(m))/t0);
        end
        if rand(1)<=p_anneal
            path(m,:,:)=child_path(m,:,:);
        end
    end
    [path_value_true,path_value]=cal_path_value(path,map);%%����·������
    [yaw_value_true,yaw_value]=cal_yaw_value(path);%%ƫ�������
    [pitch_value_true,pitch_value]=cal_pitch_value(path,map);%%���������
    t0=t0*r;%%�����¶�
    mean_path_value_true(1,n)=mean(path_value_true);%%����ƽ��·������
    mean_yaw_value_true(1,n)=mean(yaw_value_true);
    mean_pitch_value_true(1,n)=mean(pitch_value_true);
    min_path_value_true(1,n)=min(path_value_true);%%������С·������
    min_yaw_value_true(1,n)=min(yaw_value_true);
    min_pitch_value_true(1,n)=min(pitch_value_true);
end

%%�������

[~,pos]=find(fit_value==max(fit_value));
pos=pos(1);%%�ų����·��һ��һ�����ֶ�����ŵ�����
fprintf('--------------------------------------\n');
fprintf('���ž����·��ֵΪ��%.2f��\nƫ��ֵΪ��%.2f\n����ֵΪ��%.2f\n��Ӧ�ȣ�%.2f\n',path_value_true(pos),yaw_value_true(pos),pitch_value_true(pos),fit_value(pos));
fprintf('--------------------------------------\n');

% %��ͼ
% % ��������
figure;
plot(1:max_gen,mean_path_value_true(1,:),'r-');
hold on;
plot(1:max_gen,min_path_value_true(1,:),'b-');
title('·��ֵ');
legend('ƽ��ֵ','��Сֵ');
%ƫ����
figure;
plot(1:max_gen,mean_yaw_value_true(1,:),'r-');
hold on;
plot(1:max_gen,min_yaw_value_true(1,:),'b-');
title('ƫ��ֵ');
legend('ƽ��ֵ','��Сֵ');
%������
figure
plot(1:max_gen,mean_pitch_value_true(1,:),'r-');
hold on;
plot(1:max_gen,min_pitch_value_true(1,:),'b-');
title('����ֵ');
legend('ƽ��ֵ','��Сֵ');
%%·��ͼ
figure;
mesh(map.X,map.Y,map.Z');
axis([1 301 1 301 hmin hmax*1.25]);
colormap jet;
xlabel('x/38.2m');
ylabel('y/38.2m');
zlabel('z/m');
set(gca,'Position',[0.07 0.08 0.9 0.9]);
hold on;
%  for k=1:1:NP %%��������·��ͼ��
% plot3(path(k,:,1),path(k,:,2),path(k,:,3),'ro-','LineWidth',2);
% end
%��������·��ͼ��
plot3(path(pos,:,1),path(pos,:,2),path(pos,:,3),'ro-','LineWidth',2);
toc%%��ʱ����