function [yaw_value_true,yaw_value]=cal_yaw_value(path)
NP=size(path,1);%%种群数量
pathnum=size(path,2);%%路径点数量
yaw_value_true=zeros(1,NP);%%初始化
%%惩罚度pun与偏航度(单位为度)
pun_1=500;%%大于45度小于60度
pun_2=1000;%%大于60度
degree_1=45;
degree_2=60;
for k=1:1:NP
%     %%我仔细想了下，其实第一个点不需要计算偏转角。。第一个点是直线飞的
%     yaw_value(k)=atand((path(k,1,2)-path(k,2,2))/(path(k,1,1)-path(k,2,1)));
%     if(yaw_value(k)>=degree_1)
%         yaw_value(k)=yaw_value(k)+pun_1;
%     elseif (yaw_value(k)>=degree_2)
%         yaw_value(k)=yaw_value(k)+pun_2;
%     end
    %%初始偏转角计算完成
    for i=2:1:pathnum-1
        %%第一个向量
        x1=path(k,i,1)-path(k,i-1,1);
        y1=path(k,i,2)-path(k,i-1,2);
        %%第二个向量
        x2=path(k,i+1,1)-path(k,i,1);
        y2=path(k,i+1,2)-path(k,i,2);
        %%计算两向量夹角
        tmp=acosd((x1*x2+y1*y2)/(sqrt(x1^2+y1^2)*sqrt(x2^2+y2^2)));%%临时变量
        if(tmp>degree_2)
        tmp=tmp+pun_2;
        elseif (tmp>degree_1)
        tmp=tmp+pun_1;
        end
        yaw_value_true(k)=yaw_value_true(k)+tmp;
    end
end
yaw_value_true=real(yaw_value_true);
yaw_value=(max(yaw_value_true)-yaw_value_true+10^-7)/(max(yaw_value_true)-min(yaw_value_true)+10^-7);
end