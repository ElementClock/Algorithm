function [A,b,Aeq,beq]=vert2lcon(V,tol)
%% Michael Kleder 的 vert2con 函数的扩展，用于查找在给定顶点的 R^n 中定义多面体的 
%linear 约束。 这
%wrapper 扩展了 vert2con 的功能以处理以下情况
%polyhedron 在 R^n 中不是固体，即多面体定义为
% 等式和不等式约束。
% Michael Kleder 的 vert2con 函数的扩展，用于在给定顶点的情况下查找定义 R^n 中多面体的线性约束。
% 这个包装器扩展了 vert2con 的功能，以处理多面体在 R^n 中不是实心的情况，即多面体由等式和不等式约束定义。
%SYNTAX:
%
%  [A,b,Aeq,beq]=vert2lcon(V,TOL)
%N x n 矩阵 V 的行是多面体的一系列 N 个顶点
%
%在 R^n。 TOL 是等级估计容差（默认值 = 1e-10）。
%
%多面体内的任何点 x 将/必须满足
%  
%   A*x  <= b
%   Aeq*x = beq
%
%直到机器精度问题。
%
%
%EXAMPLE: 考虑对应于由 x+y+z=1, x>=0, y>=0, z>=0 定义的 3D 区域的 V=eye(3)。
%   >>[A,b,Aeq,beq]=vert2lcon(eye(3))
%     A =
% 
%         0.4082   -0.8165    0.4082
%         0.4082    0.4082   -0.8165
%        -0.8165    0.4082    0.4082
% 
% 
%     b =
% 
%         0.4082
%         0.4082
%         0.4082
% 
% 
%     Aeq =
% 
%         0.5774    0.5774    0.5774
% 
% 
%     beq =
% 
%%         0.5774


  %%initial stuff
  
    if nargin<2, tol=1e-10; end

    [M,N]=size(V);

    
    if M==1
      A=[];b=[];
      Aeq=eye(N); beq=V(:);
      return
    end
    
    

    
    
    p=V(1,:).';
    X=bsxfun(@minus,V.',p);
    
    
    % 在下面，我们需要 Q 为全列排名，我们更喜欢 E 紧凑。
    
    if M>N  %X is wide
        
     [Q, R, E] = qr(X,0);  %经济-QR确保E是紧凑的。
                           %Q 自动满列排名，因为 X 宽
                           
    else%X 很高，因此是非固体多胞体
        
     [Q, R, P]=qr(X);  %非经济 QR 使 Q 是整列排名。
     
     [~,E]=max(P);  %没有办法让 E 紧凑。 这是替代方案。
        clear P
    end
    
    
   diagr = abs(diag(R));

    
   if nnz(diagr)    
       
        %等级估计
        r = find(diagr >= tol*diagr(1), 1, 'last'); %rank estimation
    
    
        iE=1:length(E);
        iE(E)=iE;

       
       
        Rsub=R(1:r,iE).';

        if r>1

          [A,b]=vert2con(Rsub,tol);
         
        elseif r==1
            
           A=[1;-1];
           b=[max(Rsub);-min(Rsub)];

        end

        A=A*Q(:,1:r).';
        b=bsxfun(@plus,b,A*p);
        
        if r<N
         Aeq=Q(:,r+1:end).';      
         beq=Aeq*p;
        else
           Aeq=[];
           beq=[];
        end

   else %Rank=0. All points are identical
      
       A=[]; b=[];
       Aeq=eye(N);
       beq=p;
       

   end
   
   
%            ibeq=abs(beq);
%             ibeq(~beq)=1;
%            
%            Aeq=bsxfun(@rdivide,Aeq,ibeq);
%            beq=beq./ibeq;
   
           
           
function [A,b] = vert2con(V,tol)
% VERT2CON - convert a set of points to the set of inequality constraints
%            which most tightly contain the points; i.e., create
%            constraints to bound the convex hull of the given points
%
% [A,b] = vert2con(V)
%
% V = a set of points, each ROW of which is one point
% A,b = a set of constraints such that A*x <= b defines
%       the region of space enclosing the convex hull of
%       the given points
%
% For n dimensions:
% V = p x n matrix (p vertices, n dimensions)
% A = m x n matrix (m constraints, n dimensions)
% b = m x 1 vector (m constraints)
%
% NOTES: (1) In higher dimensions, duplicate constraints can
%            appear. This program detects duplicates at up to 6
%            digits of precision, then returns the unique constraints.
%        (2) See companion function CON2VERT.
%        (3) ver 1.0: initial version, June 2005.
%        (4) ver 1.1: enhanced redundancy checks, July 2005
%        (5) Written by Michael Kleder, 
%
%Modified by Matt Jacobson - March 29,2011
% 


k = convhulln(V);
c = mean(V(unique(k),:));


V = bsxfun(@minus,V,c);
A  = nan(size(k,1),size(V,2));

dim=size(V,2);
ee=ones(size(k,2),1);
rc=0;

for ix = 1:size(k,1)
    F = V(k(ix,:),:);
    if lindep(F,tol) == dim
        rc=rc+1;
        A(rc,:)=F\ee;
    end
end

A=A(1:rc,:);
b=ones(size(A,1),1);
b=b+A*c';

% eliminate duplicate constraints:
[A,b]=rownormalize(A,b);
[discard,I]=unique( round([A,b]*1e6),'rows');

A=A(I,:); % NOTE: rounding is NOT done for actual returned results
b=b(I);
return


      
 function [A,b]=rownormalize(A,b)
 %Modifies A,b data pair so that norm of rows of A is either 0 or 1
 
  if isempty(A), return; end
 
  normsA=sqrt(sum(A.^2,2));
  idx=normsA>0;
  A(idx,:)=bsxfun(@rdivide,A(idx,:),normsA(idx));
  b(idx)=b(idx)./normsA(idx);       
                  
 
 function [r,idx,Xsub]=lindep(X,tol)
%Extract a linearly independent set of columns of a given matrix X
%
%    [r,idx,Xsub]=lindep(X)
%
%in:
%
%  X: The given input matrix
%  tol: A rank estimation tolerance. Default=1e-10
%
%out:
%
% r: rank estimate
% idx:  Indices (into X) of linearly independent columns
% Xsub: Extracted linearly independent columns of X

   if ~nnz(X) %X has no non-zeros and hence no independent columns
       
       Xsub=[]; idx=[];
       return
   end

   if nargin<2, tol=1e-10; end
   

           
     [Q, R, E] = qr(X,0); 
     
     diagr = abs(diag(R));


     %Rank estimation
     r = find(diagr >= tol*diagr(1), 1, 'last'); %rank estimation

     if nargout>1
      idx=sort(E(1:r));
        idx=idx(:);
     end
     
     
     if nargout>2
      Xsub=X(:,idx);                      
     end     
