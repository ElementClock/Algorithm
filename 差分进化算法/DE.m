close all;clear;clc;
NP=50;%种群数量
D=10;%染色体长度
G=100;%进化次数
F0=0.4;%初始变异算子
CR=0.1;%交叉算子
a=-20;%寻优区间下界
b=20;%上界

x=zeros(NP,D);    % 初始种群  父本种群
v=zeros(NP,D);    % 变异种群  
u=zeros(NP,D);    % 选择种群  子代种群
%   种群初值
x=rand(NP,D)*(b-a)+a;
%   计算目标参数
for i=1:NP
    ob(i)=sum(x(i,:).^2);
end
trace=min(ob);

%差分进化循环
for gen=1:G
    %对所有种群变异操作
    for m=1:NP
        %产生不同的r1,r2,r3
        r1=randi([1,NP],1,1);
        r2=randi([1,NP],1,1);
        r3=randi([1,NP],1,1);
        %当其与本次数量重复时，重新随机
        while(r1==m)
            r1=randi([1,NP],1,1);
        end
        while(r2==r1)||(r2==m)
            r2=randi([1,NP],1,1);
        end
        while(r3==m)||(r3==r2)||(r3==r1)
            r3=randi([1,NP],1,1);
        end
        %得出变异算子
        v(m,:)=x(r1,:)+F0*(x(r2,:)-x(r3,:));%变异出新种群
    end
    
    %交叉操作
    r=randi([1,D],1,1);   %这个变异是针对整个种群的变异，不正对单个个体
    for n=1:D
        cr=rand;%随机数
        if (cr<=CR)||(n==r)%
            u(:,n)=v(:,n);
        else
            u(:,n)=x(:,n);
        end
    end
    
    %边界条件处理
    for m=1:NP
        for n=1:D
            if u(m,n)<a%当其小于时，则确定下界
                u(m,n)=a;
            end
            if u(m,n)>b%当大于时，确定上界
                u(m,n)=b;
            end
        end
    end
    
    % 自然选择
    % 计算新的适应度
    for m=1:NP
        ob1(m)=sum(u(m,:).^2);
    end
    
    for m=1:NP
        if ob1(m)<ob(m)
            x(m,:)=u(m,:);%当小于时，替换新种群
        else
            x(m,:)=x(m,:);
        end
    end
    
    % 现在x为经过选择后的种群
    for m=1:NP
        ob(m)=sum(x(m,:).^2);%更新种群适应度
    end
    trace(gen+1)=min(ob);%记录每代最小值
    tt=min(ob);%最小值
end

figure(1);
title(['差分进化算法(DE)', '最小值: ', num2str(tt)]);
xlabel('迭代次数');
ylabel('目标函数值');
plot(trace);