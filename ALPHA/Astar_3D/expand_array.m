function exp_array=expand_array(nodef_x,nodef_y,nodef_z,node_x,node_y,node_z,hn,xTarget,yTarget,zTarget,CLOSED,MAX_X,MAX_Y,MAX_Z,Display_Data)
% 函数返回扩展数组
% 此函数采用一个节点并返回扩展后的后继列表，以及计算出的 fn 值。
% 标准是没有后继者在 CLOSED 列表中。
%  load ('MapData.mat');
exp_array=[];
exp_count=1;
c2=size(CLOSED,1);%CLOSED 中的元素数，包括零
k_x = node_x - nodef_x;  %当前节点与父节点的差值
k_y = node_y - nodef_y;

%状况1
if (k_x == 1&&k_y == 0)||(k_x == 0&&k_y == 0)
    for k= 1%虽然这个for很离谱，但是和后面的状况都相同格式，我也就算了
        for j= 1:-1:-1
            for z=1:-1:-1
                %if (k~=j || k~=0)  %节点本身不是它的继任者
                s_x = node_x+k;              %s_x为当前节点下的探索节点，s为search
                s_y = node_y+j;
                s_z = node_z+z;
                %对数组边界内的节点进行检验
                if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >0 && s_z <=MAX_Z))
                    %对于所有的CLOSED表内的点检验,初始flag值为1
                    flag=1;
                    for c1=1:c2 %如果为障碍点，flag值为0，不为障碍点，flag值为1
                        if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                            flag=0;
                        end
                    end
                    %结束 for 循环以检查后继者是否在封闭列表中。
                    Heigh_Terrain = s_z - Display_Data(s_x,s_y);        %探索节点距离地表的距离
                    if Heigh_Terrain > 10
                        flag = 0;
                    end
                    if (flag == 1)      %当探索点为可前进点时
                        %exp_array的123为探索节点值，4为探索点前进成本，5为探索点与目标点的绝对值和，6为4和5的和
                        %在公式中F=G+H        6为F
                        exp_array(exp_count,1) = s_x;        %exp_count初始值1
                        exp_array(exp_count,2) = s_y;
                        exp_array(exp_count,3) = s_z;
                        Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                        if Distance_TW > 7.5
                            h_ThreatenW = 0;
                        end
                        if Distance_TW < 7.5
                            Point1_x = node_x + (s_x - node_x)/2;
                            Point1_y = node_y + (s_y - node_y)/2;
                            Point1_z = node_z + (s_z - node_z)/2;
                            Point1_Dis = sqrt((Point1_x-60)^2 + (Point1_y-70)^2);
                            node_Dis = sqrt((node_x-60)^2 + (node_y-70)^2);
                            h_ThreatenW = (1/Point1_Dis + 1/node_Dis + 1/Distance_TW)*(k^2+j^2+z^2)*(1/3);
                        end
                        h_value = 1/s_z;
                        exp_array(exp_count,4) = 1 * hn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + 10 * h_ThreatenW + 8 * h_value;
                        %4，前往节点的成本
                        %exp_array(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);
                        %节点与目标之间的距离
                        exp_array(exp_count,5) = 1 * (abs(xTarget - s_x)+abs(yTarget - s_y)+abs(zTarget - s_z));
                        exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);%fn
                        exp_count=exp_count+1;
                    end%填充 exp_array 列表！！！
                end% 对数组边界内的节点检验结束
            end
        end
    end
end


%%%%%%%%状况2
if (k_x == 1&&k_y == -1)
    for k= 1:-1:0
        for j= 0:-1:-1
            for z=1:-1:-1
                if (k~=j || k~=0)  %The node itself is not its successor
                    s_x = node_x+k;
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >0 && s_z <=MAX_Z))%node within array bound
                        flag=1;                     %是否在CLOSED列表标识为
                        for c1=1:c2
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0;
                            end
                        end%End of for loop to check if a successor is on closed list.
                        Heigh_Terrain = s_z - Display_Data(s_x,s_y);
                        if Heigh_Terrain > 10
                            flag = 0;
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW > 7.5
                                h_ThreatenW = 0;
                            end
                            if Distance_TW < 7.5
                                Point1_x = node_x + (s_x - node_x)/2;
                                Point1_y = node_y + (s_y - node_y)/2;
                                Point1_z = node_z + (s_z - node_z)/2;
                                Point1_Dis = sqrt((Point1_x-60)^2 + (Point1_y-70)^2);
                                node_Dis = sqrt((node_x-60)^2 + (node_y-70)^2);
                                h_ThreatenW = (1/Point1_Dis + 1/node_Dis + 1/Distance_TW)*(k^2+j^2+z^2)*(1/3);
                            end
                            h_value = 1/s_z;
                            exp_array(exp_count,4) = 1 * hn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + 10 * h_ThreatenW + 8 * h_value;%cost of travelling to node
                            %exp_array(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);%distance between node and goal
                            exp_array(exp_count,5) = 1 * (abs(xTarget - s_x)+abs(yTarget - s_y)+abs(zTarget - s_z));
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);%fn
                            exp_count=exp_count+1;
                        end%Populate the exp_array list!!!
                    end% End of node within array bound
                end%End of if node is not its own successor loop
            end%End of j for loop
        end%End of k for loop
    end
end
%%%%%%%%状况3
if (k_x == 1&&k_y == 1)
    for k= 1:-1:0
        for j= 1:-1:0
            for z=1:-1:-1
                if (k~=j || k~=0)  %The node itself is not its successor
                    s_x = node_x+k;
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >0 && s_z <=MAX_Z))%node within array bound
                        flag=1;                     %是否在CLOSED列表标识为
                        for c1=1:c2
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0;
                            end
                        end
                        %End of for loop to check if a successor is on closed list.
                        Heigh_Terrain = s_z - Display_Data(s_x,s_y);
                        if Heigh_Terrain > 10
                            flag = 0;
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW > 7.5
                                h_ThreatenW = 0;
                            end
                            if Distance_TW < 7.5
                                Point1_x = node_x + (s_x - node_x)/2;
                                Point1_y = node_y + (s_y - node_y)/2;
                                Point1_z = node_z + (s_z - node_z)/2;
                                Point1_Dis = sqrt((Point1_x-60)^2 + (Point1_y-70)^2);
                                node_Dis = sqrt((node_x-60)^2 + (node_y-70)^2);
                                h_ThreatenW = (1/Point1_Dis + 1/node_Dis + 1/Distance_TW)*(k^2+j^2+z^2)*(1/3);
                            end
                            h_value = 1/s_z;
                            exp_array(exp_count,4) = 1 * hn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + 10 * h_ThreatenW + 8 * h_value;%cost of travelling to node
                            %exp_array(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);%distance between node and goal
                            exp_array(exp_count,5) = 1 * (abs(xTarget - s_x)+abs(yTarget - s_y)+abs(zTarget - s_z));
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);%fn
                            exp_count=exp_count+1;
                        end%Populate the exp_array list!!!
                    end% End of node within array bound
                end%End of if node is not its own successor loop
            end%End of j for loop
        end%End of k for loop
    end
end
%%%%%%%%状况4
if (k_x == 0&&k_y == 1)
    for k= 1:-1:-1
        for j= 1
            for z=1:-1:-1
                if (k~=j || k~=0)  %The node itself is not its successor
                    s_x = node_x+k;
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >0 && s_z <=MAX_Z))%node within array bound
                        flag=1;                     %是否在CLOSED列表标识为
                        for c1=1:c2
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0;
                            end
                        end
                        %End of for loop to check if a successor is on closed list.
                        Heigh_Terrain = s_z - Display_Data(s_x,s_y);
                        if Heigh_Terrain > 10
                            flag = 0;
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW > 7.5
                                h_ThreatenW = 0;
                            end
                            if Distance_TW < 7.5
                                Point1_x = node_x + (s_x - node_x)/2;
                                Point1_y = node_y + (s_y - node_y)/2;
                                Point1_z = node_z + (s_z - node_z)/2;
                                Point1_Dis = sqrt((Point1_x-60)^2 + (Point1_y-70)^2);
                                node_Dis = sqrt((node_x-60)^2 + (node_y-70)^2);
                                h_ThreatenW = (1/Point1_Dis + 1/node_Dis + 1/Distance_TW)*(k^2+j^2+z^2)*(1/3);
                            end
                            h_value = 1/s_z;
                            exp_array(exp_count,4) = 1 * hn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + 10 * h_ThreatenW + 8 * h_value;%cost of travelling to node
                            %exp_array(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);%distance between node and goal
                            exp_array(exp_count,5) = 1 * (abs(xTarget - s_x)+abs(yTarget - s_y)+abs(zTarget - s_z));
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);%fn
                            exp_count=exp_count+1;
                        end%Populate the exp_array list!!!
                    end% End of node within array bound
                end%End of if node is not its own successor loop
            end%End of j for loop
        end%End of k for loop
    end
end
%%%%%%%%状况5
if (k_x == 0&&k_y == -1)
    for k= 1:-1:-1
        for j= -1
            for z=1:-1:-1
                if (k~=j || k~=0)  %The node itself is not its successor
                    s_x = node_x+k;
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >0 && s_z <=MAX_Z))%node within array bound
                        flag=1;                     %是否在CLOSED列表标识为
                        for c1=1:c2
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0;
                            end
                        end%End of for loop to check if a successor is on closed list.
                        Heigh_Terrain = s_z - Display_Data(s_x,s_y);
                        if Heigh_Terrain > 10
                            flag = 0;
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW > 7.5
                                h_ThreatenW = 0;
                            end
                            if Distance_TW < 7.5
                                Point1_x = node_x + (s_x - node_x)/2;
                                Point1_y = node_y + (s_y - node_y)/2;
                                Point1_z = node_z + (s_z - node_z)/2;
                                Point1_Dis = sqrt((Point1_x-60)^2 + (Point1_y-70)^2);
                                node_Dis = sqrt((node_x-60)^2 + (node_y-70)^2);
                                h_ThreatenW = (1/Point1_Dis + 1/node_Dis + 1/Distance_TW)*(k^2+j^2+z^2)*(1/3);
                            end
                            h_value = 1/s_z;
                            exp_array(exp_count,4) = 1 * hn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + 10 * h_ThreatenW + 8 * h_value;%cost of travelling to node
                            %exp_array(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);%distance between node and goal
                            exp_array(exp_count,5) = 1 * (abs(xTarget - s_x)+abs(yTarget - s_y)+abs(zTarget - s_z));
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);%fn
                            exp_count=exp_count+1;
                        end%Populate the exp_array list!!!
                    end% End of node within array bound
                end%End of if node is not its own successor loop
            end%End of j for loop
        end%End of k for loop
    end
end
%%%%%%%%状况6
if (k_x == -1&&k_y == 1)
    for k= 0:-1:-1
        for j= 1:-1:0
            for z=1:-1:-1
                if (k~=j || k~=0)  %The node itself is not its successor
                    s_x = node_x+k;
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >0 && s_z <=MAX_Z))%node within array bound
                        flag=1;                     %是否在CLOSED列表标识为
                        for c1=1:c2
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0;
                            end
                        end
                        %End of for loop to check if a successor is on closed list.
                        Heigh_Terrain = s_z - Display_Data(s_x,s_y);
                        if Heigh_Terrain > 10
                            flag = 0;
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW > 7.5
                                h_ThreatenW = 0;
                            end
                            if Distance_TW < 7.5
                                Point1_x = node_x + (s_x - node_x)/2;
                                Point1_y = node_y + (s_y - node_y)/2;
                                Point1_z = node_z + (s_z - node_z)/2;
                                Point1_Dis = sqrt((Point1_x-60)^2 + (Point1_y-70)^2);
                                node_Dis = sqrt((node_x-60)^2 + (node_y-70)^2);
                                h_ThreatenW = (1/Point1_Dis + 1/node_Dis + 1/Distance_TW)*(k^2+j^2+z^2)*(1/3);
                            end
                            h_value = 1/s_z;
                            exp_array(exp_count,4) = 1 * hn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + 10 * h_ThreatenW + 8 * h_value;%cost of travelling to node
                            %exp_array(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);%distance between node and goal
                            exp_array(exp_count,5) = 1 * (abs(xTarget - s_x)+abs(yTarget - s_y)+abs(zTarget - s_z));
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);%fn
                            exp_count=exp_count+1;
                        end%Populate the exp_array list!!!
                    end% End of node within array bound
                end%End of if node is not its own successor loop
            end%End of j for loop
        end%End of k for loop
    end
end
%%%%%%%%状况7
if (k_x == -1&&k_y == 0)
    for k= -1
        for j= 1:-1:-1
            for z=1:-1:-1
                if (k~=j || k~=0)  %The node itself is not its successor
                    s_x = node_x+k;
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >0 && s_z <=MAX_Z))%node within array bound
                        flag=1;                     %是否在CLOSED列表标识为
                        for c1=1:c2
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0;
                            end
                        end
                        %End of for loop to check if a successor is on closed list.
                        Heigh_Terrain = s_z - Display_Data(s_x,s_y);
                        if Heigh_Terrain > 10
                            flag = 0;
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW > 7.5
                                h_ThreatenW = 0;
                            end
                            if Distance_TW < 7.5
                                Point1_x = node_x + (s_x - node_x)/2;
                                Point1_y = node_y + (s_y - node_y)/2;
                                Point1_z = node_z + (s_z - node_z)/2;
                                Point1_Dis = sqrt((Point1_x-60)^2 + (Point1_y-70)^2);
                                node_Dis = sqrt((node_x-60)^2 + (node_y-70)^2);
                                h_ThreatenW = (1/Point1_Dis + 1/node_Dis + 1/Distance_TW)*(k^2+j^2+z^2)*(1/3);
                            end
                            h_value = 1/s_z;
                            exp_array(exp_count,4) = 1 * hn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + 10 * h_ThreatenW + 8 * h_value;%cost of travelling to node
                            %exp_array(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);%distance between node and goal
                            exp_array(exp_count,5) = 1 * (abs(xTarget - s_x)+abs(yTarget - s_y)+abs(zTarget - s_z));
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);%fn
                            exp_count=exp_count+1;
                        end%Populate the exp_array list!!!
                    end% End of node within array bound
                end%End of if node is not its own successor loop
            end%End of j for loop
        end%End of k for loop
    end
end
%%%%%%%%状况8
if (k_x == -1&&k_y == -1)
    for k= 0:-1:-1
        for j= 0:-1:-1
            for z=1:-1:-1
                if (k~=j || k~=0)  %The node itself is not its successor
                    s_x = node_x+k;
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >0 && s_z <=MAX_Z))%node within array bound
                        flag=1;                     %是否在CLOSED列表标识为
                        for c1=1:c2
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0;
                            end
                        end
                        %End of for loop to check if a successor is on closed list.
                        Heigh_Terrain = s_z - Display_Data(s_x,s_y);
                        if Heigh_Terrain > 10
                            flag = 0;
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW > 7.5
                                h_ThreatenW = 0;
                            end
                            if Distance_TW < 7.5
                                Point1_x = node_x + (s_x - node_x)/2;
                                Point1_y = node_y + (s_y - node_y)/2;
                                Point1_z = node_z + (s_z - node_z)/2;
                                Point1_Dis = sqrt((Point1_x-60)^2 + (Point1_y-70)^2);
                                node_Dis = sqrt((node_x-60)^2 + (node_y-70)^2);
                                h_ThreatenW = (1/Point1_Dis + 1/node_Dis + 1/Distance_TW)*(k^2+j^2+z^2)*(1/3);
                            end
                            h_value = 1/s_z;
                            exp_array(exp_count,4) = 1 * hn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + 10 * h_ThreatenW + 8 * h_value;%cost of travelling to node
                            %exp_array(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);%distance between node and goal
                            exp_array(exp_count,5) = 1 * (abs(xTarget - s_x)+abs(yTarget - s_y)+abs(zTarget - s_z));
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);%fn
                            exp_count=exp_count+1;
                        end%Populate the exp_array list!!!
                    end% End of node within array bound
                end%End of if node is not its own successor loop
            end%End of j for loop
        end%End of k for loop
    end
end