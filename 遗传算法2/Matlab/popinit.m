%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������ƣ���ʼ����Ⱥ
%%��ڲ�������Ⱥ����  ��������
%%���ڲ�������ʼ��Ⱥ
%%˵����
    %%��ʼ��Ⱥ�ĸ����X��������Y������ֿ���ţ��ֱ���ھ��� x,y�У���Ϊ��������ֵ����
    %%��ʼ��Ⱥ�Ĳ�������ȥ��ʼ������ֹ�����㣬�������x�ᡢy��������������Ӵ�С��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x,y]=popinit(popsize,chromlength,x0,y0,xn,yn)
i=1;
for j=1:1:popsize
    while i<=chromlength
        if i==1
            x(j,i)=x0;
            y(j,i)=y0;
            i=i+1;
        elseif i<chromlength-1
            if rand<0.5
                x(j,i)=(xn-x(j,i-1))*rand+x(j,i-1);
                y(j,i)=(yn-y0)*rand;
            else
                y(j,i)=(yn-y(j,i-1))*rand+y(j,i-1);
                x(j,i)=(xn-x0)*rand;
            end
            fit=calfitvalue([x(j,i-1),x(j,i)],[y(j,i-1),y(j,i)]);
            if fit==0
%                 i=i-1;
            else
                i=i+1;
            end
        elseif i==chromlength-1
            if rand<0.5
                x(j,i)=(xn-x(j,i-1))*rand+x(j,i-1);
                y(j,i)=(yn-y0)*rand;
            else
                y(j,i)=(yn-y(j,i-1))*rand+y(j,i-1);
                x(j,i)=(xn-x0)*rand;
            end
            fit=calfitvalue([x(j,i-1),x(j,i),xn],[y(j,i-1),y(j,i),yn]);
            if fit==0
                 i=1;
            else
                i=i+1;
            end
        elseif i==chromlength
            x(j,i)=xn;
            y(j,i)=yn;
            i=i+1;
        end
    end
    i=1;
end
% x=20.0*rand(popsize,chromlength);
% y=20.0*rand(popsize,chromlength);
% x(:,1)=0;
% y(:,1)=0;
% x(:,chromlength)=20;
% y(:,chromlength)=20;
% [px,py]=size(x);
% % if rand<0.5
% %     for i=1:1:px
% %     x(i,:)=sort(x(i,:));
% % %     y(i,:)=sort(y(i,:));
% %     end 
% % else
% %     for i=1:1:px
% % %     x(i,:)=sort(x(i,:));
% %     y(i,:)=sort(y(i,:));
% %     end 
% % end
% for i=1:1:px
% x(i,:)=sort(x(i,:));
% y(i,:)=sort(y(i,:));
% end