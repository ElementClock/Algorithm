
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������ƣ����и���ѡ����
%%��ڲ�������ʼ��Ⱥ    ��Ⱥ��Ӧ��
%%���ڲ�������Ѹ���  ��Ѹ�����Ӧ��
%%˵����
    %%������Ӧ�ȴ�С����ѡ����Ѹ��塣��Ӧ�����ĸ��彫��ѡ������Ϊ��������ֵ���ء�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bestx,besty,bestfit]=best(x,y,fitvalue)
    [px,py]=size(x);
    bestx=x(1,:);
    besty=y(1,:);
    bestfit=fitvalue(1);
    for i=2:px
        if fitvalue(i)>bestfit
            bestx=x(i,:);
            besty=y(i,:);
            bestfit=fitvalue(i);
        end
    end
end