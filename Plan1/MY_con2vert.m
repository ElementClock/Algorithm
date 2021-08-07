function [V,nr] = MY_con2vert(A,b)
% 由 Hyongju Park 编辑（2015 年 8 月 11 日）
% *** 修改函数跳过错误信息
% ------------------------------------------------- ---
% CON2VERT - 将约束不等式的凸集转换为该集合这些不等式相交处的顶点百分比；即，
% 解决“顶点枚举”问题。此外，
% 识别不等式列表中的冗余条目。
%
% V = con2vert(A,b)
% [V,nr] = con2vert(A,b)
%
% 转换由定义的多面体（凸多边形、多面体等）
% 不等式系统 A*x <= b 到顶点列表 V. 每个 ROWV 的 % 是一个顶点。对于 n 个变量：
% A = m x n 矩阵，其中 m >= n（m 个约束，n 个变量）
% b = m x 1 向量（m 约束）
% V = p x n 矩阵（p 个顶点，n 个变量）
% nr = A 中非冗余约束的行列表
%
% 注释：(1) 该程序采用原始双多胞体方法。
% (2) 在大于 2 的维度上，冗余顶点可以
% 使用这种方法出现。该程序检测冗余
% 最多 6 位精度，然后返回
% 唯一顶点。
% (3) 非边界约束给出错误结果；所以，
% 程序检测到非边界约束并返回
%   一个错误。您可能希望实现大型“框”约束如果您需要引入边界，请在变量上使用
%。例如，
% 如果 x 是一个人的身高（以英尺为单位），则框约束
% -1 <= x <= 1000 将是诱导的合理选择
% 有界，因为 x 没有可能的解
% 被边界框禁止。
% (4) 这个程序要求可行域有一些
% 在所有维度上的有限范围。例如，可行的
% 区域不能是二维空间中的线段，也不能是平面
% 在 3-D 空间中。
% (5) 至少需要两个维度。
% (6) 参见伴随函数 VERT2CON。
%
% EXAMPLES:
%
% % FIXED CONSTRAINTS:
% A=[ 0 2; 2 0; 0.5 -0.5; -0.5 -0.5; -1 0];
% b=[4 4 0.5 -0.5 0]';
% figure('renderer','zbuffer')
% hold on
% [x,y]=ndgrid(-3:.01:5);
% p=[x(:) y(:)]';
% p=(A*p <= repmat(b,[1 length(p)]));
% p = double(all(p));
% p=reshape(p,size(x));
% h=pcolor(x,y,p);
% set(h,'edgecolor','none')
% set(h,'zdata',get(h,'zdata')-1) % keep in back
% axis equal
% V=con2vert(A,b);
% plot(V(:,1),V(:,2),'y.')
% 
% % RANDOM CONSTRAINTS:
% A=rand(30,2)*2-1;
% b=ones(30,1);
% figure('renderer','zbuffer')
% hold on
% [x,y]=ndgrid(-3:.01:3);
% p=[x(:) y(:)]';
% p=(A*p <= repmat(b,[1 length(p)]));
% p = double(all(p));
% p=reshape(p,size(x));
% h=pcolor(x,y,p);
% set(h,'edgecolor','none')
% set(h,'zdata',get(h,'zdata')-1) % keep in back
% axis equal
% set(gca,'color','none')
% V=con2vert(A,b);
% plot(V(:,1),V(:,2),'y.')
% 
% % HIGHER DIMENSIONS:
% A=rand(15,5)*1000-500;
% b=rand(15,1)*100;
% V=con2vert(A,b)
% 
% % NON-BOUNDING CONSTRAINTS (ERROR):
% A=[0 1;1 0;1 1];
% b=[1 1 1]';
% figure('renderer','zbuffer')
% hold on
% [x,y]=ndgrid(-3:.01:3);
% p=[x(:) y(:)]';
% p=(A*p <= repmat(b,[1 length(p)]));
% p = double(all(p));
% p=reshape(p,size(x));
% h=pcolor(x,y,p);
% set(h,'edgecolor','none')
% set(h,'zdata',get(h,'zdata')-1) % keep in back
% axis equal
% set(gca,'color','none')
% V=con2vert(A,b); % should return error
% 
% % NON-BOUNDING CONSTRAINTS WITH BOUNDING BOX ADDED:
% A=[0 1;1 0;1 1];
% b=[1 1 1]';
% A=[A;0 -1;0 1;-1 0;1 0];
% b=[b;4;1000;4;1000]; % bound variables within (-1,1000)
% figure('renderer','zbuffer')
% hold on
% [x,y]=ndgrid(-3:.01:3);
% p=[x(:) y(:)]';
% p=(A*p <= repmat(b,[1 length(p)]));
% p = double(all(p));
% p=reshape(p,size(x));
% h=pcolor(x,y,p);
% set(h,'edgecolor','none')
% set(h,'zdata',get(h,'zdata')-1) % keep in back
% axis equal
% set(gca,'color','none')
% V=con2vert(A,b);
% plot(V(:,1),V(:,2),'y.','markersize',20)
%
% % JUST FOR FUN:
% A=rand(80,3)*2-1;
% n=sqrt(sum(A.^2,2));
% A=A./repmat(n,[1 size(A,2)]);
% b=ones(80,1);
% V=con2vert(A,b);
% k=convhulln(V);
% figure
% hold on
% for i=1:length(k)
%     patch(V(k(i,:),1),V(k(i,:),2),V(k(i,:),3),'w','edgecolor','none')
% end
% axis equal
% axis vis3d
% axis off
% h=camlight(0,90);
% h(2)=camlight(0,-17);
% h(3)=camlight(107,-17);
% h(4)=camlight(214,-17);
% set(h(1),'color',[1 0 0]);
% set(h(2),'color',[0 1 0]);
% set(h(3),'color',[0 0 1]);
% set(h(4),'color',[1 1 0]);
% material metal
% for x=0:5:720
%     view(x,0)
%     drawnow
% end
flg = 0;
c = A\b;
tol = 1e-07;
if ~all(abs(A*c - b) < tol)
    %obj1 = @(c) obj(c, {A,b});
    [c,~,ef] = fminsearch( @(x)obj(x, {A,b}),c);
%     [c,~,ef] = fminsearch(@obj,c,A,b);
    if ef ~= 1
        flg = 1;
    end
end
if flg ==1
    V = [];
%     error('Unable to locate a point within the interior of a feasible region.')
else
b = b - A*c;
D = A ./ repmat(b,[1 size(A,2)]);
[~,v2] = convhulln([D;zeros(1,size(D,2))]);
[k,v1] = convhulln(D);
%if v2 > v1
%    error('Non-bounding constraints detected. (Consider box constraints on variables.)')
%end
nr = unique(k(:));
G  = zeros(size(k,1),size(D,2));
for ix = 1:size(k,1)
    F = D(k(ix,:),:);
    G(ix,:)=F\ones(size(F,1),1);
end
V = G + repmat(c',[size(G,1),1]);
[~,I]=unique(num2str(V,6),'rows');
V=V(I,:);
end
return
function d = obj(c,param)
A = param{1};
b = param{2};
% ,A,b
% A=params{1};
% b=params{2};
d = A*c-b;
k=(d>=-1e-15);
d(k)=d(k)+1;
d = max([0;d]);
return



