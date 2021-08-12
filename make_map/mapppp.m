clc,clear;
load taiwan;                                      %台湾30m的高程图
map.Z=taiwan(2000:3000,4000:5000);
map.X=1:1001;
map.Y=1:1001;
map.X=map.X*30;                  %此处扩张为1m每刻度，如果此处变更，应当在Plan出最后绘图处变更即可，其余各处不影响
map.Y=map.Y*30;
figure;
axis('equal');
mesh(map.X,map.Y,map.Z');
save taiwan_map.mat map;