function [yaw_value_true,yaw_value]=cal_yaw_value(path)
NP=size(path,1);%%��Ⱥ����
pathnum=size(path,2);%%·��������
yaw_value_true=zeros(1,NP);%%��ʼ��
%%�ͷ���pun��ƫ����(��λΪ��)
pun_1=500;%%����45��С��60��
pun_2=1000;%%����60��
degree_1=45;
degree_2=60;
for k=1:1:NP
%     %%����ϸ�����£���ʵ��һ���㲻��Ҫ����ƫת�ǡ�����һ������ֱ�߷ɵ�
%     yaw_value(k)=atand((path(k,1,2)-path(k,2,2))/(path(k,1,1)-path(k,2,1)));
%     if(yaw_value(k)>=degree_1)
%         yaw_value(k)=yaw_value(k)+pun_1;
%     elseif (yaw_value(k)>=degree_2)
%         yaw_value(k)=yaw_value(k)+pun_2;
%     end
    %%��ʼƫת�Ǽ������
    for i=2:1:pathnum-1
        %%��һ������
        x1=path(k,i,1)-path(k,i-1,1);
        y1=path(k,i,2)-path(k,i-1,2);
        %%�ڶ�������
        x2=path(k,i+1,1)-path(k,i,1);
        y2=path(k,i+1,2)-path(k,i,2);
        %%�����������н�
        tmp=acosd((x1*x2+y1*y2)/(sqrt(x1^2+y1^2)*sqrt(x2^2+y2^2)));%%��ʱ����
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