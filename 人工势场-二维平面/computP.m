function [ output ] = computP( curr,over,obstacle )
%COMPUTP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
  k_att=1;
repu=0;
k_rep=100;
Q_star=2;
%���㵱ǰ������յ������
attr=1/2*k_att*(norm(curr-over))^2;

%�����ϰ����뵱ǰ��ĳ���
%�趨�ϰ��ĳ������ð뾶Ϊ2
for i=1:size(obstacle,2)
    if norm(curr-obstacle(:,i))<=Q_star
        repu=repu+1/2*k_rep*(1/norm(curr-obstacle(:,i))-1/Q_star)^2;
    else
        repu=repu+0;
    end
end

output=attr+repu;

end

