%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author:Michael Jacob Mathew

% The following calculates the heuristic of each cell.
% Here eucledian distance is used.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [Heuristic]=CalculateHeuristic(grid,goal)

Heuristic=zeros(size(grid));

% for i=1:size(grid,1)
%     for j=1:size(grid,2)
%         Heuristic(i,j)=sqrt((i-goal(1))^2+(j-goal(2))^2);
%     end
% end

for i=1:size(grid,1)
    for j=1:size(grid,2)
        Heuristic(i,j)=abs(i-goal(1))+abs(j-goal(2));
    end
end

end


%SIMPLE EUCLEADIAN DISTANCE LIKE THE COMMENTED CODE ALSO WILL WORK