
function []=SmoothPath(Path,PlotSize,SmoothFactor)
weight_data = 0.01;
weight_smooth = SmoothFactor;
tolerance=0.00001;
% Path for testing
% Path=[0,0;
%       0,1;
%       0,2;
%       1,2;
%       2,2;
%       3,2;
%       4,2;
%       4,3;
%       4,4]

NewPath=Path;

change=tolerance;
while (change>=tolerance)
    change=0;
    for i = 2:size(Path,1)-1
        for j =1:size(Path,2)
            aux=NewPath(i,j);
%             NewPath(i,j)=NewPath(i,j)+weight_data*(Path(i,j)-NewPath(i,j));
            NewPath(i,j)=NewPath(i,j)+weight_data*(Path(i,j)-NewPath(i,j))+weight_smooth*(NewPath(i+1,j)+NewPath(i-1,j)-2*NewPath(i,j));
            change=change+abs(aux-NewPath(i,j));
        end
    end
end
% figure;
plot(NewPath(:,2),NewPath(:,1),'Color','magenta')
% set(gca,'XLim',[0,PlotSize(2)+2],'YLim',[0,PlotSize(1)+2]);
set(gca,'YDir','reverse');
end
