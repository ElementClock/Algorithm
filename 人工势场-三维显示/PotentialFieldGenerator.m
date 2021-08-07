function [potential_field] = PotentialFieldGenerator(map, dest_coordinate)
MapSize = size(map);
[x, y] = meshgrid (1:MapSize(1), 1:MapSize(2));

a_scale = 1/500;
attractive_potential = a_scale*((x-dest_coordinate(1)).^2+(y-dest_coordinate(2)).^2);

rho = (bwdist(map)/100)+1;
influence = 1.5;
r_scale = 1000;
repulsive_potential = r_scale*((1./rho - 1/influence).^2);
repulsive_potential (rho > influence) = 0;

potential_field = attractive_potential + repulsive_potential;

figure;
subplot(1,3,1);
mesh(attractive_potential);
camlight('left');
axis equal;
title('Attractive Potential');

subplot(1,3,2);
mesh(repulsive_potential);
camlight('left');
axis equal;
title('Repulsive Potential');

subplot(1,3,3);
mesh(potential_field);
camlight('left');
axis equal;
title('Total Potential');
colormap cool;
end

