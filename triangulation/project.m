function [x] = project(X,cam)

% function [x] = project(X,cam)
%
% Carry out projection of 3D points into 2D given the camera parameters
% We assume that the camera with the given intrinsic parameters produces
% images by projecting onto a focal plane at distance cam.f along the 
% z-axis of the camera coordinate system.
%
% Our convention is that the camera starts out the origin (in world
% coordinates), pointing along the z-axis.  It is first rotated by 
% some matrix cam.R and then translated by the vector cam.t.
%
% Input:
%
%  X : a 3xN matrix containing the point coordinates in 3D world coordinates (meters)
%
%  intrinsic parameters:
%
%  cam.f : focal length [meters]  (scalar)
%  cam.m : pixel magnification factor [pixels/meter]  (2x1 vector)
%  cam.c : image center (principal point) [in pixels]  (2x1 vector)
%
%  extrinsic parameters:
%
%  cam.R : camera rotation matrix (3x3 matrix)
%  cam.t : camera translation matrix (3x1 vector)
%
% Output:
%
%  x : a 2xN matrix containing the point coordinates in the 2D image (pixels)

%%%%%STEPS:
% 1. transform the points in the world to the camera coordinate frame
% 2. OPTIONAL: drop points which have non-positive z coordinates
% since we can't see them in the camera.  This can be useful for 
% debugging purposes
% 3. project the points down onto the image plane
% 4. scale by focal length and pixel magnification 
% 5. add in camera principal point offset.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. transform the points in the world to the camera coordinate frame
%create world to camera matrix
hcat = horzcat(cam.R', -(cam.R'*cam.t));
worldToCam_m = vertcat(hcat, [0,0,0,1]);
[m,n] = size(X);
hg = ones(1,n);
X_hg = vertcat(X,hg);
x_cam = worldToCam_m * X_hg;

x_coord = ones(2,n);
%steps 3, 4 and 5
for i=1:m
    for j=1:n
        %projection
        xtemp = x_cam(1,j)/x_cam(3,j)*cam.f;
        ytemp = x_cam(2,j)/x_cam(3,j)*cam.f;
        %physical to pixel coordinates
        xtemp = xtemp*cam.m(1) + cam.c(1); %principal point offset
        ytemp = ytemp*cam.m(2) + cam.c(2); %principal point offset
        x_coord(1,j) = xtemp;
        x_coord(2,j) = ytemp;
    end
end

x=x_coord;
