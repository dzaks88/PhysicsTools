zz = linspace(0,99,100);
xx = linspace(0,99,100)-50;
yy = linspace(0,99,100)-50;

dx = xx(2)-xx(1);
dy = yy(2)-yy(1);
dz = zz(2)-zz(1);

[X,Y,Z] = meshgrid(xx,yy,zz);

Vol = floor(Z);

ct = struct(...
        'rczSize', size(Vol), ...
        'xyzOrigin', [xx(1), yy(1), zz(1)], ...
        'xyzSpacing',  [dx,dy,dz], ...
        'Vol', Vol ...
        );

ctshow3(ct, ct.Vol, [0, 0, 50]);

save('doseCtVolume.mat','-struct','ct');