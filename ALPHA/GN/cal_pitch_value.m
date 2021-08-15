function [pitch_value_true,pitch_value]=cal_pitch_value(path,map)
NP=size(path,1);%%种群数量
pathnum=size(path,2);%%路径点数量
pitch_value_true=zeros(1,NP);%%初始化俯仰角数据
%%俯仰角惩罚值与俯仰角（单位为度）
pun_1=500;
pun_2=1000;
degree_1=45;
degree_2=60;
%%计算部分
for k=1:1:NP
    for i=1:1:pathnum-1
        %%计算底边长度
        length=sqrt(((path(k,i+1,1)-path(k,i,1))*map.gap)^2+((path(k,i+1,2)-path(k,i,2))*map.gap)^2);
        high=abs(path(k,i+1,3)-path(k,i,3));%%计算高度变化的绝对值
        tmp=atand(high/length);
        
        if length==0&&high==0          %判断当前后两点重合时，角度为0
         tmp=0;
         end
        
        if(tmp>degree_2)
            tmp=tmp+pun_2;
        elseif (tmp>degree_1)
            tmp=tmp+pun_1;
        end
        pitch_value_true(k)=pitch_value_true(k)+tmp;
    end
end
pitch_value_true=real(pitch_value_true);
pitch_value=(max(pitch_value_true)-pitch_value_true+10^-7)/(max(pitch_value_true)-min(pitch_value_true)+10^-7);
end