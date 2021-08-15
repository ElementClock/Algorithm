% 以center(x,y,z)、Base-Radius(R)和圆柱高度(h)的坐标为输入输出创建圆柱状障碍物的函数如图所示}
function cyl_obs(x0,y0,z0,R,h)
[x,y,z]=cylinder(R);
x=x+x0;
y=y+y0;
z=z*h+z0;
surf(x,y,z)
hold on
end