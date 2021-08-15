function  makeData
load alphaMap
map.Z=double(map.Z);
map.Z=ceil((map.Z-min(min(map.Z)))/100);
k=1;
terrainData=[];
for i=1:length(map.X)
    for j=1:length(map.Y)
        z_Data=map.Z(i,j);
        for z_data=1:z_Data
        terrainData(k,1)=i;
        terrainData(k,2)=j;
        terrainData(k,3)=z_data;
        k=k+1;
    end
    end
end
save Data terrainData map
end