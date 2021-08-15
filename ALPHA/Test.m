clc,clear;
save astarData
save rrtData
save gnData
for NNN=1:100
    addpath GN
    [T,L]=testime(1);
    gnData(NNN,:)=[T,L];
    save('gnData.mat','gnData','-append');
    rmpath GN
end

for NNN=1:100
    addpath Astar
    [T,L]=testime(2);
    astarData(NNN,:)=[T,L];
    save('astarData.mat','astarData','-append');
    rmpath Astar
end

for NNN=1:100
    addpath RRT2
    [T,L]=testime(3);
    rrtData(NNN,:)=[T,L];
    save('rrtData.mat','rrtData','-append');
    rmpath RRT2
end

rmpath GN
rmpath Astar
rmpath RRT2