%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������ƣ�ѡ����
%%��ڲ�������ʼ��Ⱥ    ��Ⱥ��Ӧ��
%%���ڲ���������Ⱥ
%%˵����
    %%ѡ����������̶ĵķ�ʽ���С�
    %%��֤��Ӧ��Ϊ0����Ⱥ��һ������ѡ�С�Ҳ���Ǿ����ϰ����·����ѡ�еĸ��ʱ���Ϊ0��
    %%����Ҫ��֤ѡ��֮�����Ⱥ������֮ǰһ�¡�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [newx,newy]=selection(x,y,fitvalue)

totalfit=sum(fitvalue); %����Ӧֵ֮��
fitvalue1=fitvalue/totalfit; %�������屻ѡ��ĸ���
fitvalue=cumsum(fitvalue1); %�� fitvalue=[1 2 3 4]���� cumsum(fitvalue)=[1 3 6 10] 
[px,py]=size(fitvalue);
ms=sort(rand(px,1)); %��С��������       ����һ�� px�� 1�� ���������Ȼ���С��������
fitin=1;
newin=1;
[maxd,I]=max(fitvalue1);
while newin<=px
if  (ms(newin))<fitvalue(fitin) && fitvalue1(fitin)>0  %fitvalue1(fitin)>0 ��֤��Ӧ��Ϊ0�ĸ��岻��ѡ��
newx(newin,:)=x(fitin,:);
newy(newin,:)=y(fitin,:);
newin=newin+1;
else
fitin=fitin+1;
end
% if newin>1
% newx(newin,:)=newx(newin-1,:);
% newy(newin,:)=newy(newin-1,:);
% newin=newin+1;fitvalue1(fitin)==maxd ||
% end
end

end
