%用于算法的列表
function [WayPoints,OPEN_COUNT] = A_star(MAX_X,MAX_Y,MAX_Z,xval,yval,zval,xTarget,yTarget,zTarget,MAP,CLOSED,Display_Data,MIN_Final_Data)
%设置最优路径节点
WayPoints = [];
%设置开始节点
xStart = xval;
yStart = yval;
zStart = zval;
%用于算法的列表
%OPEN LIST STRUCTURE
%IS ON LIST 1/0 | X val | Y val | Parent X val | Parent Y val | h(n) | g(n) 启发函数| f(n)|
OPEN=[];
%CLOSED LIST STRUCTURE
%X val | Y val | Z val |
% CLOSED=zeros(MAX_VAL,2);
CLOSED_COUNT=size(CLOSED,1);
%将起始节点设置为第一个节点
xNode=xval;
yNode=yval;
zNode=zval;
xFNode = xval;
yFNode = yval;
zFNode = zval;
OPEN_COUNT=1;
path_cost=0;
goal_distance=distanced(xNode,yNode,zNode,xTarget,yTarget,zTarget);%计算目标距离
%insert_open(当前x,当前y,父节点x,父节点y,路径h(n),启发g(n),f(n))
OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,zNode,xNode,yNode,zNode,path_cost,goal_distance,goal_distance);
OPEN(OPEN_COUNT,1)=0;
CLOSED_COUNT=CLOSED_COUNT+1;
CLOSED(CLOSED_COUNT,1)=xNode;
CLOSED(CLOSED_COUNT,2)=yNode;
CLOSED(CLOSED_COUNT,3)=zNode;
NoPath=1;%是否有路径判断符1有，0无
% 启动算法
while((xNode ~= xTarget || yNode ~= yTarget || zNode ~= zTarget) && NoPath == 1)         %当前点不为终点且判断有路径时
    %expand_array(父节点x,父节点y,当前节点x,当前节点y,h(n),目标x,目标y,CLOSED,表X,表y,地形上界y)
    %返回值exp_array：扩展x,扩展y,扩展z,h(n),g(n),f(n)
    exp_array=expand_array(xFNode,yFNode,zFNode,xNode,yNode,zNode,path_cost,xTarget,yTarget,zTarget,CLOSED,MAX_X,MAX_Y,MAX_Z,Display_Data);
    exp_count=size(exp_array,1);
    %使用后继节点打开更新列表
    %打开列表格式
    %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
    %扩展阵列格式
    %|X val |Y val ||h(n) |g(n)|f(n)|
    for i=1:exp_count
        flag=0;             
        %判断exp_array中节点在不在OPEN列表中，0不在，1在
        for j=1:OPEN_COUNT
            if(exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3) && exp_array(i,3) == OPEN(j,4) )
                OPEN(j,10)=min(OPEN(j,10),exp_array(i,6)); 
                %#ok<*SAGROW>
                if OPEN(j,10)== exp_array(i,6)
                    %UPDATE PARENTS,gn,hn
                    OPEN(j,5)=xNode;
                    OPEN(j,6)=yNode;
                    OPEN(j,7)=zNode;
                    OPEN(j,8)=exp_array(i,4);
                    OPEN(j,9)=exp_array(i,5);
                end
                %最小 fn 检查结束
                flag=1;
            end
            %节点检查结束
            %         if flag == 1
            %             break;
        end
        %End of j for
        if flag == 0
            OPEN_COUNT = OPEN_COUNT+1;
            OPEN(OPEN_COUNT,:)=insert_open(exp_array(i,1),exp_array(i,2),exp_array(i,3),xNode,yNode,zNode,exp_array(i,4),exp_array(i,5),exp_array(i,6));
        end
        %将新元素插入 OPEN 列表结束
    end
    %End of i for
    
    %END OF WHILE LOOP
    %找出 fn 最小的节点
    index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget);
    if (index_min_node ~= -1)
        %将 xNode 和 yNode 设置为 fn 最小的节点
        xNode=OPEN(index_min_node,2);
        yNode=OPEN(index_min_node,3);
        zNode=OPEN(index_min_node,4);
        xFNode=OPEN(index_min_node,5);
        yFNode=OPEN(index_min_node,6);
        zFNode=OPEN(index_min_node,7);
        path_cost=OPEN(index_min_node,8);
        %更新到达父节点的成本
        %将节点移动到列表 CLOSED
        CLOSED_COUNT=CLOSED_COUNT+1;
        CLOSED(CLOSED_COUNT,1)=xNode;
        CLOSED(CLOSED_COUNT,2)=yNode;
        CLOSED(CLOSED_COUNT,3)=zNode;
        OPEN(index_min_node,1)=0;
    else
        %目标不存在路径！！
        NoPath=0;
        %退出循环！
    end
    %index_min_node 检查结束
end
%End of While Loop
%一旦算法运行 最优路径是通过从最后一个节点（如果它是目标节点）开始
%然后识别其父节点直到到达起始节点来生成的。这是最优路径
i=size(CLOSED,1);
Optimal_path=[];
xval=CLOSED(i,1);
yval=CLOSED(i,2);
zval=CLOSED(i,3);
i=1;
Optimal_path(i,1)=xval;
Optimal_path(i,2)=yval;
Optimal_path(i,3)=zval;
i=i+1;

if ( (xval == xTarget) && (yval == yTarget) && (zval == zTarget))
    inode=0;
    %遍历OPEN并确定父节点
    parent_x=OPEN(node_index(OPEN,xval,yval,zval),5);%node_index 返回节点的索引
    parent_y=OPEN(node_index(OPEN,xval,yval,zval),6);
    parent_z=OPEN(node_index(OPEN,xval,yval,zval),7);
    
    while( parent_x ~= xStart || parent_y ~= yStart || parent_z ~= zStart)
        Optimal_path(i,1) = parent_x;
        Optimal_path(i,2) = parent_y;
        Optimal_path(i,3) = parent_z;
        %Get the grandparents:-)
        inode=node_index(OPEN,parent_x,parent_y,parent_z);
        parent_x=OPEN(inode,5);%node_index 返回节点的索引
        parent_y=OPEN(inode,6);
        parent_z=OPEN(inode,7);
        i=i+1;
    end
    j=size(Optimal_path,1);
    plot3(Optimal_path(:,1)+.5,Optimal_path(:,2)+.5,Optimal_path(:,3)+.5,'b','linewidth',5);
    WayPoints = Optimal_path;
else
    pause(1);
    h=msgbox('Sorry, No path exists to the Target!','warn');
    uiwait(h,5);
end