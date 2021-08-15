function i_min = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget)
% 函数返回具有最小 fn 的节点
% 此函数以列表 OPEN 作为其输入，并返回成本最低的节点的索引
 temp_array=[];
 k=1;
 flag=0;
 goal_index=0;
 for j=1:OPEN_COUNT
     if (OPEN(j,1)==1)
         temp_array(k,:)=[OPEN(j,:) j]; 
         if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget && OPEN(j,4)==zTarget)
             flag=1;
             goal_index=j;%存储目标节点的索引
         end
         k=k+1;
     end
 end%获得所有Open表的节点
 
 if flag == 1 % 后继者之一是目标节点，因此发送此节点
     i_min=goal_index;
 end
 %发送最小节点的索引
 if size(temp_array ~= 0)
  [min_fn,temp_min]=min(temp_array(:,10));%临时数组中最小节点的索引
  i_min=temp_array(temp_min,11);%OPEN 数组中最小节点的索引
 else
     i_min=-1;%temp_array 为空，即没有更多路径可用。
 end
 
end