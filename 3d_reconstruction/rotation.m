function Rot_xyz = rotation(x,y,z)

%
%  function X = triangulate(xL,xR,camL,camR)
%
%  INPUT:
%   
%   x, y, z: angles to rotate in respective coordinate
%
%  OUTPUT:
%
%    Rot_xyz : 3x3 rotational matrix
%
%

thx = x;
 
Rx = [ 1 0 0 ; ...
       0 cos(thx) -sin(thx) ; ...
       0 sin(thx) cos(thx) ];
   
thy = y; 
Ry = [  cos(thy)   0  -sin(thy) ; ...
              0    1         0 ; ...
       sin(thy)   0  cos(thy) ];
   
thz = z;
Rz = [  cos(thz) -sin(thz) 0 ; ...
       sin(thz) cos(thz) 0 ; ...
               0        0 1 ];
Rot_xyz = Rx*Rz*Ry;
