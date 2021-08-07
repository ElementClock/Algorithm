function in = inhull(Pos,Bnd,tess,tol)
%%  inhull: 测试一组点是否在凸包内
% usage: in = inhull(testpts,xyz)
% usage: in = inhull(testpts,xyz,tess)
% usage: in = inhull(testpts,xyz,tess,tol)
% 
% arguments: (input)
%  Pos - 要测试的 n*p 数组，n 个数据点，p 维
%  如果您有很多点要测试，则对整个集合调用一次此函数是最有效的。
%
%  xyz - convhulln 使用的凸包顶点的 mxp 数组。
%
%  tess - 由 convhulln 生成的曲面细分（或三角剖分）
%  如果 tess 为空或未提供，则将生成它。
%
%  tol - (OPTIONAL) 
% 对包含在凸包中的测试的容忍度。
% 您可以将 tol 视为一个点可能位于船体外部但仍被视为在船体表面上的距离。
% 由于数值倾斜，这里什么也做不了。 我可能猜测 tol 的半智能值是
%
%         tol = 1.e-13*mean(abs(xyz(:)))
%
%  在更高的维度中，浮点运算的数值问题可能会建议使用更大的 tol 值。
%
%       DEFAULT: tol = 0
%
% arguments: (output)
% in - nx1 逻辑向量
%        in(i) == 1 --> 第 i 个点在凸包内。
%  
% 用法示例：第一个点应该在里面，第二个在外面
%
%  xy = randn(20,2);
%  tess = convhulln(xy);
%  testpoints = [ 0 0; 10 10];
%  in = inhull(testpoints,xy,tess)
%
% in = 
%      1
%      0
%
% 船体（hull）中退化单纯形数的非零计数将生成警告（4 维或更多维）。 
% 可以使用以下命令禁用此警告：
%
%   警告（'关闭'，'inhull：退化'）
%
% 另见：convhull、convhulln、delaunay、delaunayn、tsearch、tsearchn
%%

% 获取数组大小
% m points, p dimensions
p = size(Bnd,2);                        %检验提供的点是否符合要求
[n,c] = size(Pos);
if p ~= c
  error 'Bnd 和 Pos 必须具有相同的列数'
end
if p < 2
  error '点必须至少位于二维空间中。'
end

% nargin是当前函数输入变量的个数

% 是否提供了凸包？
if (nargin<3) || isempty(tess)        %或的运算    当输入变量不小于3时验证tess是否为空
  tess = convhulln(Bnd);              %返回 其中每一行表示构成凸包的三角剖分的一个分面。值表示输入点的行索引。
end
[nt,c] = size(tess);          %返回行和列
if c ~= p
  error 'tess 数组与维度 p 空间不兼容'
end

% 是否提供了 tol？
if (nargin<4) || isempty(tol)               %当输入变量不小于4时验证tol是否为空
  tol = 0;
end

% 构建法向量
switch p
  case 2
    % 二维真的很简单
    nrmls = (Bnd(tess(:,1),:) - Bnd(tess(:,2),:)) * [0 1;-1 0];
    
    % 有退化的边缘吗？
    del = sqrt(sum(nrmls.^2,2));
    degenflag = (del<(max(del)*10*eps));
    if sum(degenflag)>0
      warning('inhull:degeneracy',[num2str(sum(degenflag)), ...
        '在凸包中识别的退化边缘 '])
      
      % 我们需要删除那些退化的法向量
      nrmls(degenflag,:) = [];
      nt = size(nrmls,1);
    end
  case 3
    % 对 3-d 使用矢量化叉积
    ab = Bnd(tess(:,1),:) - Bnd(tess(:,2),:);
    ac = Bnd(tess(:,1),:) - Bnd(tess(:,3),:);
    nrmls = cross(ab,ac,2);
    degenflag = false(nt,1);
  otherwise
    % 在更高维度上做更多的工作，
    nrmls = zeros(nt,p);
    degenflag = false(nt,1);
    for i = 1:nt
      %以防万一请注意，可以在这一行中使用 bsxfun，但我选择不这样做以保持兼容性。 旧版本的用户仍在使用此代码。
      %  nullsp = null(bsxfun(@minus,xyz(tess(i,2:end),:),xyz(tess(i,1),:)))';
      nullsp = null(Bnd(tess(i,2:end),:) - repmat(Bnd(tess(i,1),:),p-1,1))';
      if size(nullsp,1)>1
        degenflag(i) = true;
        nrmls(i,:) = NaN;
      else
        nrmls(i,:) = nullsp;
      end
    end
    if sum(degenflag)>0
      warning('inhull:degeneracy',[num2str(sum(degenflag)), ...
        ' 在凸包中识别的退化单纯形'])
      
      % 我们需要删除那些退化的法向量
      nrmls(degenflag,:) = [];
      nt = size(nrmls,1);
    end
end

% 将法向量缩放到单位长度
nrmllen = sqrt(sum(nrmls.^2,2));
% 再次，bsxfun 可以在这里使用...
%  nrmls = bsxfun(@times,nrmls,1./nrmllen);
nrmls = nrmls.*repmat(1./nrmllen,1,p);          %repmat重复数组副本

% 船体的中心点
center = mean(Bnd,1);

% 凸包中每个单纯形平面内的任意点
a = Bnd(tess(~degenflag,1),:);

% 确保法线向内指向这条线也可以使用 bsxfun ...
%  dp = sum(bsxfun(@minus,center,a).*nrmls,2);
dp = sum((repmat(center,nt,1) - a).*nrmls,2);
k = dp<0;
nrmls(k,:) = -nrmls(k,:);

% We want to test if:  dot((x - a),N) >= 0
%如果对于船体的所有面都是如此，则 x 位于船体内部。
% Change this to dot(x,N) >= dot(a,N)
aN = sum(nrmls.*a,2);

% 测试，注意点多
in = false(n,1);

% 如果 n 太大，我们需要担心点积会占用大量内存。
memblock = 1e6;
blocks = max(1,floor(n/(memblock/nt)));
aNr = repmat(aN,1,length(1:blocks:n));
for i = 1:blocks
   j = i:blocks:n;
   if size(aNr,2) ~= length(j)
      aNr = repmat(aN,1,length(j));
   end
   in(j) = all((nrmls*Pos(j,:)' - aNr) >= -tol,1)';
end



