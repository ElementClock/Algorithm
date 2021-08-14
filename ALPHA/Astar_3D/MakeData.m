function  MakeData()
%制作地图的数据
clc,clear;
load ('alphaMap.mat');
% MAX_X = max(map.X);
% MAX_Y = max(map.Y);
% MAX_Z = max(max(map.Z))+100;
MAX_X = 100;
MAX_Y = 100;
MAX_Z = 50;
Final_Data=double(map.Z);
% mesh(map.X/30,map.Y/30,map.Z/50);
axis('equal');
MAX_Final_Data = max(max(map.Z));
MIN_Final_Data = min(min(map.Z));
%此处是缩小计算范围，因为Y轴的起始点不是从0开始
xNum=length(map.X);
yNum=length(map.Y);
for i=1:xNum
    for j=1:yNum
        New_Data(i,j) = ceil((map.Z(i,j)-MIN_Final_Data)/50);
        %ceil 向正无穷取整，取整是为了定位坐标
        Display_Data(i,j) =double( (map.Z(i,j)-MIN_Final_Data)/50);
    end
end


%映射矩阵初始化，因为空间的值设定为2
% 获取障碍物、目标和机器人位置
% 用输入值初始化 MAP
% Obstacle=-1,Target = 0,Robot=1,Space=2
%制作随机地形数据
MAP=2*(ones(MAX_X,MAX_Y,MAX_Z));
for i=1:MAX_X
    for j=1:MAX_Y
        Z_UpData = New_Data(i,j);
        for z = 1:Z_UpData
            MAP(i,j,z) = -1;           %填充地表以下的都是障碍
        end
    end
end


%将所有障碍放在关闭列表中
CLOSED=[];
k=1;%计数器
for i=1:MAX_X
    for j=1:MAX_Y
        Z_UpData = New_Data(i,j);
        for z = 1:Z_UpData
            CLOSED(k,1)=i;
            CLOSED(k,2)=j;
            CLOSED(k,3)=z;
            k=k+1;
        end
    end
end
%输入禁飞区信息
% c2=size(CLOSED,1);
% for i_z=1:20
%     for i_x=1:100
%         for i_y=1:100
%             
%             
%             flag = 1;
%             Length = (i_x-30)^2 + (i_y-30)^2;
%             for c1=1:c2
%                 if (i_x == CLOSED(c1,1) && i_y == CLOSED(c1,2) && i_z == CLOSED(c1,3))
%                     flag = 0;
%                 end
%             end
%             
%             if Length <= 25 && flag == 1
%                 %当距离小于5且当前点不为障碍时（即为地表之上时），设置为障碍
%                 CLOSED(c2+1,1)=i_x;
%                 CLOSED(c2+1,2)=i_y;
%                 CLOSED(c2+1,3)=i_z;
%                 c2 = c2+1;
%             end
%             
%             
%         end
%     end
% end
%输入异常气象区域信息
% k = 1;
% c3 = size(CLOSED,1);
% for i_z=1:10
%     for i_x=1:100
%         for i_y=1:100
%             flag = 1;
%             Length = (i_x-60)^2 + (i_y-30)^2;
%             for c1=1:c3
%                 if (i_x == CLOSED(c1,1) && i_y == CLOSED(c1,2) && i_z == CLOSED(c1,3))
%                     flag = 0;
%                 end
%             end
%             if Length <= 56.25 & flag == 1
%                 Threaten_Weather(k,1)=i_x;
%                 Threaten_Weather(k,2)=i_y;
%                 Threaten_Weather(k,3)=i_z;
%                 k = k+1;
%             end
%         end
%     end
% end
save MapData1 MAX_X MAX_Y MAX_Z MAP CLOSED Final_Data Display_Data
