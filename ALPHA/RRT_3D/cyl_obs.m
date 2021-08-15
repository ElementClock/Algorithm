
% {Function used to create the cylinder shaped obstacle by taking
% coordinates of center(x,y,z), Base-Radius(R) and cylinder height(h)
% as input and output is the plot in figure}
function cyl_obs(x0,y0,z0,R,h)
[x,y,z]=cylinder(R);
x=x+x0;
y=y+y0;
z=z*h+z0;
surf(x,y,z)
hold on
end