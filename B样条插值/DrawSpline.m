% DrawSpline.m文件
function Bp=DrawSpline(n, k, P, NodeVector)
% B样条的绘图函数
num_Bp=-1;
hold on;       %设置保持
grid on;       %设置网格
xlabel('x轴');
ylabel('y轴');
zlabel('z轴');
view(45,27);   %设置看图的角度
% 已知n+1个控制顶点P(i), k次B样条，P是2*(n+1)矩阵存控制顶点坐标, 节点向量NodeVector

%标点
plot3(P(1, 1:n+1), P(2, 1:n+1), P(3, 1:n+1),...
                    'o','LineWidth',1,...    %设置曲线粗细
                    'MarkerEdgeColor','k',...%设置数据点边界颜色
                    'MarkerFaceColor','g',...%设置填充颜色
                    'MarkerSize',6);         %设置数据点型大小
%绘制点连直线条
line(P(1, 1:n+1), P(2, 1:n+1), P(3, 1:n+1));

Nik = zeros(n+1, 1);
for u = 0 : 0.001 : 1-0.005
    num_Bp=num_Bp+1;
    for i = 0 : 1 : n
        Nik(i+1, 1) = BaseFunction(i, k , u, NodeVector);
    end
    p_u = P * Nik;
    if u == 0
        tempx = p_u(1,1);
        tempy = p_u(2,1);
        tempz = p_u(3,1);
        line([tempx p_u(1,1)], [tempy p_u(2,1)],[tempz p_u(3,1)],...
            'Marker','.','LineStyle','-', 'Color',[.3 .6 .9], 'LineWidth',3);
    else
        
        line([tempx p_u(1,1)], [tempy p_u(2,1)],[tempz p_u(3,1)],...
            'Marker','.','LineStyle','-', 'Color',[.3 .6 .9], 'LineWidth',3);
        tempx = p_u(1,1);
        tempy = p_u(2,1);
        tempz = p_u(3,1);
     
    end
          Bp(1,num_Bp+1)=p_u(1,1);
          Bp(2,num_Bp+1)=p_u(2,1);
          Bp(3,num_Bp+1)=p_u(3,1);   
end
