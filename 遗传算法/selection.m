function [child_path]=selection(fit_value,path)
%%ѡ��
%%fit_value����Ӧ�ȣ�path��·��
NP=size(path,1);
pathnum=size(path,2);
child_path=zeros(NP,pathnum,3);
fitness=fit_value;
%%���̶ķ���
totalfit=sum(fitness);%%��������Ӧ�����
p_fit=fitness/totalfit;%%�����Ӧ�ȸ����ʴ�С
p_fit=cumsum(p_fit);%%��p_fit�������
rnum = sort(rand(NP, 1));
i=1;j=1;
while(i<=NP)
    if rnum(i)<p_fit(j)
        child_path(i,:,:)=path(j,:,:);
        i=i+1;
    else
        j=j+1;
    end
end
end