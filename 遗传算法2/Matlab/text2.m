%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������ƣ�������
%%��ڲ�������
%%���ڲ�������
%%˵������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
pc=0.7;   %�������
pm=1; %�������
po=0;
c=1.2;
[x,y]=popinit(100,15,0,0,20,20)   %������ʼ��Ⱥ
D=calfitvalue(x,y);
for i=1:1:60             %���ý�������
% [newx,newy]=selection(x,y,D);              %ѡ��
[newx,newy]=crossover(x,y,pc);       %����
[newx,newy]=mutation(newx,newy,pm);        %����
D=calfitvalue(newx,newy);                  %���¼�����Ӧ��
[newx,newy]=selection(newx,newy,D);        %ѡ��     ��֤�����������Ⱥ���������ϰ���
D=calfitvalue(newx,newy); 
% [newx,newy]=optimization(newx,newy,po);
D=calfitvalue(newx,newy);                  %���¼�����Ӧ��    ѡ��֮�����Ⱥ��Ӧ��Ҳ�Ѿ������仯�����Ա������¼���
 errorx(i)=i; 
%     if max(D)-min(D)>0
%     D=D*15/(max(D)-min(D));
%     end
    sumd(i)=sum(D)/max(size(D));
    if max(D)-sumd(i)>0
%     D=D*sumd(i)*(c-1)/(max(D)-sumd(i))+sumd(i)*(max(D)-c*sumd(i))/(max(D)-sumd(i));
    end
    if min(D)==0
        erroraver(i)=max(D)-16;
    else
        erroraver(i)=max(D)-min(D);
    end
    errormax(i)=max(D);

[bestx,besty,bestfit]=best(newx,newy,D);   %ѡ����Ѹ���
bbestx(i,:)=bestx;                         %������Ѹ���
bbesty(i,:)=besty;
bbestfit(i)=bestfit;
x=newx;
y=newy;
end
[bbbestfit,I]=max(bbestfit)                %����ѡ���������Ѹ����� ��Ӧ�����ĸ��壬��Ϊ����ֵ���
bbbestx=bbestx(I,:);
bbbesty=bbesty(I,:);
for i=1:1:10
    [bbbestx,bbbesty]=optimization(bbbestx,bbbesty,1);
end
% ������Ӧ�Ⱥ����н����Ļ���ģ�ͣ�����ϰ���
fill([0,0,8,8,0],[2,4,4,2,2],[0,0,0])
hold on
fill([10,10,13,13,10],[1,4,4,1,1],[0,0,0])
hold on
fill([9,9,16,16,9],[11,13,13,11,11],[0,0,0])
hold on
fill([2,2,6,6,2],[12,15,15,12,12],[0,0,0])
hold on
fill([14,14,15,15,14],[5,9,9,5,5],[0,0,0])
hold on
fill([6,6,10,10,6],[7,9,9,7,7],[0,0,0])
hold on
fill([0,0,3,3,0],[8,9,9,8,8],[0,0,0])
hold on
fill([17,20,20,17,17],[13,13,11,11,13],[0,0,0])
hold on
% grid on
%%��������·����·��
plot(bbbestx,bbbesty,'r-')
hold on
plot(bbbestx,bbbesty,'b.','MarkerSize',15)
hold on
figure('Name','��Ӧ�Ȳ�ֵ')
plot(errorx,erroraver)
hold on
figure('Name','��Ӧ��ƽ��ֵ')
plot(errorx,sumd)
hold on
figure('Name','��Ӧ�����ֵ')
plot(errorx,errormax)
hold on
