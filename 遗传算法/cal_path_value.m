function [path_value_true,path_value]=cal_path_value(path,map)
%%����·������
NP=size(path,1);                            %���ڲ���ȫ�ֱ����������Լ���ȡ��Ⱥ����
pathnum=size(path,2);
path_value_true=zeros(1,NP);
 for k=1:1:NP
    for i=1:1:pathnum-1
        d(1)=map.gap*abs(path(k,i,1)-path(k,i+1,1));
        d(2)=map.gap*abs(path(k,i,2)-path(k,i+1,2));
        d(3)=abs(path(k,i,3)-path(k,i+1,3));
        d=d.^2;
        path_value_true(1,k)=path_value_true(1,k)+sqrt(d(1)+d(2)+d(3));
    end
end
path_value=(max(path_value_true)-path_value_true+10^-7)/(max(path_value_true)-min(path_value_true)+10^-7);
end%%��������
