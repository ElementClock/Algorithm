function []=drawEnvironment(grid)

% grid=NewGrid();  
[row,col]=size(grid);
scaleX=1;
scaleY=1;

grid1=zeros(size(grid));

for i=1:row
    grid1(i,:)=grid((row-i+1),:);
end

% grid=grid1;

 for y=1:row 
    for x=1:col
        
        plot(x,y,'S','Color','black');
        hold on;
        if(grid(y,x))
%             plot(x,y,'S','Color','black');
%             hold on;
            if(x+1<=col && grid(y,x+1)==1)
                line(scaleX.*[x,x+1],scaleY.*[y,y],'Color','r','LineWidth',3);
            end
            if(y+1<=row && grid(y+1,x)==1)
                line(scaleX.*[x,x],scaleY.*[y,y+1],'Color','r','LineWidth',3);
            end
        end
    end
 end

 line([0,col+1],[0,0],'Color','g','LineWidth',2);
 line([col+1,col+1],[0,row+1],'Color','g','LineWidth',2);
 line([col+1,0],[row+1,row+1],'Color','g','LineWidth',2);
 line([0,0],[row+1,0],'Color','g','LineWidth',2);
 set(gca,'XLim',[-1,size(grid,2)+2],'YLim',[-1,size(grid,1)+2]);
 set(gca,'YDir','reverse');
%  set(gca,'XLim',[0,col+1],'YLim',[0,row+1]);
 
%  hold off;