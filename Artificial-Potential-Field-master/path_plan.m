function [ point ] = path_plan(begin,over,obstacle)
%PATH_PLAN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
iters=1; %��������
curr=begin;
testR=0.2;   %����8���Բ�İ뾶Ϊ0.5
while (norm(curr-over)>0.2) &&  (iters<=2000)
    point(:,iters)=curr;
%     attr=attractive(curr,over);
%     repu=repulsion(curr,obstacle);
    %curoutput=computP(curr,over,obstacle);
    %���㵱ǰ�㸽���뾶Ϊ0.2��8��������ܣ�Ȼ���õ�ǰ������ܼ�ȥ8���������ȡ��ֵ���ģ�ȷ�����
    %���򣬾�����һ�������ĵ�
    
    %������˸��������
    for i=1:8
        testPoint(:,i)=[testR*sin((i-1)*pi/4)+curr(1);testR*cos((i-1)*pi/4)+curr(2)];
        testOut(:,i)=computP(testPoint(:,i),over,obstacle);
        %�ҳ�����С�ľͿ�����
    end
    [temp num]=min(testOut);
    
    %�����ľ���Ϊ0.1
    curr=(curr+testPoint(:,num))/2;
    plot(curr(1),curr(2),'og');
    pause(0.01);
    iters=iters+1;
end
end

