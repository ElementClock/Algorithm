function [child_path]=cross(path,pc)
%%����
%%path�Ǹ�����pc�ǽ������
NP=size(path,1);%%��Ⱥ����
pathnum=size(path,2);%%·��������
tmp=zeros(1,pathnum,3);%%�м����
child_path=path;
for n=1:1:NP
%     %%���㽻��
%         if rand(1,1)<=pc
%         i=randi([1,NP],1,1);
%         j=randi([1,NP],1,1);
%         k=randi([2 pathnum-1],1,1);
%         tmp(1,:,:)=path(i,:,:);
%         child_path(i,k:1:pathnum,:)=child_path(j,k:1:pathnum,:);
%         child_path(i,k:1:pathnum,:)=tmp(1,k:1:pathnum,:);
%         end
        %%���㽻��
    if rand(1,1)<=pc
        i=randi([1 NP],1,1);%%ѡ���һ������
        j=randi([1 NP],1,1);%%ѡ��ڶ�������
        k1=randi([1 pathnum],1,1);%%ѡ���һ��·����
        k2=randi([1 pathnum],1,1);%%ѡ��ڶ���·����
        %%�����ǽ�������
        tmp(1,:,:)=path(i,:,:);
        if(k1<=k2)
            child_path(i,k1:1:k2,:)=child_path(j,k1:1:k2,:);
            child_path(j,k1:1:k2,:)=tmp(1,k1:1:k2,:);
        else
            child_path(i,k2:1:k1,:)=child_path(j,k2:1:k1,:);
            child_path(j,k2:1:k1,:)=tmp(1,k2:1:k1,:);
        end
    end
end