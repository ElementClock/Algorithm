%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������ƣ����캯��
%%��ڲ�������ʼ��Ⱥ    �������
%%���ڲ���������Ⱥ
%%˵����
    %%ͨ��������ķ�ʽ����ĳһ�����Ƿ���졣 rand<pm
    %%���췽ʽ���������һ���ڻ���������Χ�ڵ���������Ϊ����㣬�������һ���µĵ��滻ԭ���ĵ㡣��
    %%�������֮�����Ⱥ��������дӴ�С������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [newx,newy]=mutation(x,y,pm)
D=calfitvalue(x,y);
[px,py]=size(x);
newx=x;
newy=y;
lx=x;
ly=y;
loop=0;
c=1;
% D=calfitvalue(x,y);
% [maxd,I]=max(D);
for i=1:1:px-1
    if rand<pm %&& (D(i)<maxd || D(i+1)<maxd )
%     while loop==0
%         c=c+1;
    mpoint=round(rand*py);

    if mpoint<=1
        mpoint=2;
    end
    if mpoint==py
        mpoint=py-1;
    end
%     %���������ѡȡ
%     
%     lx(i,mpoint)=2*rand+x(i,mpoint)-1;
%     ly(i,mpoint)=2*rand+y(i,mpoint)-1;
%     lD=calfitvalue(lx(i,:),ly(i,:));
%     if lD>D(i) ||c==50
%         loop=1;
%     end
%     end
    newx(i,mpoint)=round(rand*py);
    newy(i,mpoint)=round(rand*py);
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