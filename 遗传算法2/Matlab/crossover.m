%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������ƣ����溯��
%%��ڲ�������ʼ��Ⱥ    �������
%%���ڲ���������Ⱥ
%%˵����
    %%ͨ��������ķ�ʽ����ĳһ�����Ƿ񽻲档 rand<pc
    %%���淽ʽ���������һ���ڻ���������Χ�ڵ���������Ϊ���濪ʼ�㣬����һ��Ⱥ���е��㽻�档
    %%�������֮�����Ⱥ��������дӴ�С������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [newx,newy]=crossover(x,y,pc)
[px,py]=size(x);
newx=ones(size(x)); 
newy=ones(size(y)); 
D=calfitvalue(x,y);
[maxd,I]=max(D);
for i=1:1:px-1
if rand<pc% && (D(i)<maxd || D(i+1)<maxd )
cpoint=round(rand*py);
newx(i,:)=[x(i,1:cpoint),x(i+1,cpoint+1:py)];
newx(i+1,:)=[x(i+1,1:cpoint),x(i,cpoint+1:py)];
newy(i,:)=[y(i,1:cpoint),y(i+1,cpoint+1:py)];
newy(i+1,:)=[y(i+1,1:cpoint),y(i,cpoint+1:py)];
else
newx(i,:)=x(i,:);
newx(i+1,:)=x(i+1,:);
newy(i,:)=y(i,:);
newy(i+1,:)=y(i+1,:);
end
end
% if rand<0.5
%     for i=1:1:px
%     x(i,:)=sort(x(i,:));
% %     y(i,:)=sort(y(i,:));
%     end 
% else
%     for i=1:1:px
% %     x(i,:)=sort(x(i,:));
%     y(i,:)=sort(y(i,:));
%     end 
% end
% for i=1:1:px
% newx(i,:)=sort(newx(i,:));
% newy(i,:)=sort(newy(i,:));
% end 
end
