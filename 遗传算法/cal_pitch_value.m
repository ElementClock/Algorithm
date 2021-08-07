function [pitch_value_true,pitch_value]=cal_pitch_value(path,map)
NP=size(path,1);%%��Ⱥ����
pathnum=size(path,2);%%·��������
pitch_value_true=zeros(1,NP);%%��ʼ������������
%%�����ǳͷ�ֵ�븩���ǣ���λΪ�ȣ�
pun_1=500;
pun_2=1000;
degree_1=45;
degree_2=60;
%%���㲿��
 for k=1:1:NP
    for i=1:1:pathnum-1
        %%����ױ߳���
         length=sqrt(((path(k,i+1,1)-path(k,i,1))*map.gap)^2+((path(k,i+1,2)-path(k,i,2))*map.gap)^2);
         high=abs(path(k,i+1,3)-path(k,i,3));%%����߶ȱ仯�ľ���ֵ
         tmp=atand(high/length);
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