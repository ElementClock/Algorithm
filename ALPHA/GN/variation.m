function [child_path]=variation(path,pv,map)
%%变异操作，pv是变异概率
NP=size(path,1);
pathnum=size(path,2);
child_path=path;
for i=1:1:NP
    if rand(1)<= pv    %小于变异概率直接退出
        
        
        for y=1:1:floor(pathnum/2)%%好多个点发生变异
            j=randi([2 pathnum-1],1,1);
            k(1)=child_path(i,j,1);
            k(2)=floor((child_path(i,j-1,2)+child_path(i,j+1,2))/2)+randi([-5,5],1,1);%%round(normrnd(0,3,[1 1]));
           
            if k(2)>map.x_Interval%确保y轴的值不超出空间
                k(2)=map.x_Interval;
            elseif k(2)<1
                k(2)=1;
            end
            
            k(3)=map.Z(k(1),k(2))+randi([50 300],1,1);
            child_path(i,j,:)=k;
        end
        
        
    end
end
end