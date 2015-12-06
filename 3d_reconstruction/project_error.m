
function err = project_error(params,fixedparams,X,x) %assuming xL is "x"


% function [x] = project_error(params,fixedparams,X,x)
%
%
% Input:
%
% params : an 8x1 vector containing the camera parameters which we 
%   will optimize over.  this should include:
% 
%    fmx,fmy - the product of the focal length and mx (recall that we can't 
%      recover both independently since they always appear multiplied together)
%    thx,thy,thz - camera rotation around the x,y and z axis
%    tx,ty,tz - camera translation vector entries
%   
% fixedparams : 2x1 vector of additional camera parameters we won't optimize over
%               cx,cy - the camera center.  we will just assume this is the 
%               center of the image.
%
% X: a 3xN matrix containing the point coordinates in 3D world coordinates (meters)
%
% x: a 2xN matrix containing the point coordinates in the camera image (pixels)
%
% Output:
%
%  err : a 1xN matrix containing the difference between x and project(X,cam)
%
%

% unpack parameters.
fmx = params(1);
fmy = params(2);
mx = [fmx;fmy];
cx = fixedparams(1);
cy = fixedparams(2);

% build up cam data structure from parameters
cam.c = [cx;cy];
cam.f = 1; %assume focal length is one
cam.m = mx;
cam.R = rotation(params(3),params(4),params(5));
cam.t = [params(6);params(7); params(8)];

% compute projection
xproject = project(X,cam);

% compute the vector of reprojection errors
err = xproject-x; 
