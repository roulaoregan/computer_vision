function X = triangulate(xL,xR,camL,camR)

%
%  function X = triangulate(xL,xR,camL,camR)
%
%  INPUT:
%   
%   xL,xR : points in left and right images  (2xN arrays)
%   camL,camR : left and right camera parameters
%
%
%  OUTPUT:
%
%    X : 3D coordinate of points in world coordinates (3xN array)
%
% 1. convert from pixel coordinates back into meters with unit focal 
% length.  call the results xRm and xLm
%
% 2. make the left camera the origin of the world coordinate system by 
% transforming both cameras appropriately in order to find the rotation
% and translation (R,t) relating the two cameras
%
% 3. solve the equation:  
%   Z_r * xRm = R* Z_l * xLm + t
% for the Zs using svd.m

% 4. use Z_l compute the 3D coordinates XL in left camera reference frame

% 5. map XL back to world coordinates X

[m,n] = size(xL);

% STEP 1. convert from pixel coordinates back into meters with unit focal 
% length.  call the results xRm and xLm
xLm = ones(m,n);
for i=1:m
    for j=1:n
        xtemp = (xL(1,j)- camL.c(1))/(camL.m(1)*camL.f);
        ytemp = (xL(2,j) - camL.c(2))/(camL.m(2)*camL.f);
        xLm(1,j) = xtemp;
        xLm(2,j) = ytemp;        
    end
end

xRm = ones(m,n);
for i=1:m
    for j=1:n
        xtemp = (xR(1,j) - camR.c(1))/(camR.m(1)*camR.f);
        ytemp = (xR(2,j)- camR.c(2))/(camR.m(2)*camR.f) ;
        xRm(1,j) = xtemp;
        xRm(2,j) = ytemp;
    end
end
% 2. make the left camera the origin of the world coordinate system by 
% transforming both cameras appropriately in order to find the rotation
% and translation (R,t) relating the two cameras

%keep original camera positions for later
originalCamL.R = camL.R;
originalCamL.t = camL.t;
originalCamR.R = camR.R;
originalCamR.t = camR.t;
%camL is at origin
newcamL.R = camL.R'; %inverse rot
newcamL.t = -camL.t; %translate
%rotate camR in resp. to camL
newcamR.R = camR.R*camL.R';
newcamR.t = camL.R'*(camR.t-camL.t);
%camRnew.t = inv(camL.R)*(camR.t-camL.t)
%R = camR.R';
%t = newcamR.t;%camR.t;
hg = ones(1,n);
xLm = [xLm;hg];
xRm = [xRm;hg];
xLmR = -newcamR.R'*xLm;
% 3. solve the equation: 
% Z_r * xRm = R* Z_l * xLm + t using least squares
XL = ones(3,n);
for i=1:n
    A = [xRm(:,i) -xLmR(:,i)];
    z = A\newcamR.t;   
    XL(:,i) = z(2) * xLm(:,i);
end
% 4. use Z_l compute the 3D coordinates XL in left camera reference frame
XL_hg = vertcat(XL, hg);
%undo the rotation and translation
rotateback_m = horzcat(originalCamL.R, originalCamL.t);
% 5. map XL back to world coordinates X
X = rotateback_m*XL_hg;
