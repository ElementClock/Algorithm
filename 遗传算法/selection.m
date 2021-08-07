function [child_path]=selection(fit_value,path)
%%选择
%%fit_value是适应度，path是路径
NP=size(path,1);
pathnum=size(path,2);
child_path=zeros(NP,pathnum,3);
fitness=fit_value;
%%轮盘赌方法
totalfit=sum(fitness);%%将所有适应度求和
p_fit=fitness/totalfit;%%求出适应度各概率大小
p_fit=cumsum(p_fit);%%将p_fit概率求和
rnum = sort(rand(NP, 1));
i=1;j=1;
while(i<=NP)
    if rnum(i)<p_fit(j)
        child_path(i,:,:)=path(j,:,:);
        i=i+1;
    else
        j=j+1;
    end
end
end