function [child_path]=cross(path,pc)
%%交叉
%%path是父代，pc是交叉概率
NP=size(path,1);%%种群数量
pathnum=size(path,2);%%路径点数量
tmp=zeros(1,pathnum,3);%%中间变量
child_path=path;
for n=1:1:NP
%     %%单点交叉
%         if rand(1,1)<=pc
%         i=randi([1,NP],1,1);
%         j=randi([1,NP],1,1);
%         k=randi([2 pathnum-1],1,1);
%         tmp(1,:,:)=path(i,:,:);
%         child_path(i,k:1:pathnum,:)=child_path(j,k:1:pathnum,:);
%         child_path(i,k:1:pathnum,:)=tmp(1,k:1:pathnum,:);
%         end
        %%两点交叉
    if rand(1,1)<=pc
        i=randi([1 NP],1,1);%%选择第一个子类
        j=randi([1 NP],1,1);%%选择第二个子类
        k1=randi([1 pathnum],1,1);%%选择第一个路径点
        k2=randi([1 pathnum],1,1);%%选择第二个路径点
        %%以下是交换操作
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