
function [cam,x,X] = calibrate(imfile)

% function [cam,x,X] = calibrate(imfile);
%
%  This function takes an image file name, loads in the image
%  and uses it for camera calibration.  The user clicks
%  on corner points of a grid (assumed to be 10x8).  These
%  points along with their true coordinates are used to 
%  optimize the camera parameters with respect to the reprojection
%  error.
%
%  Output: 
%     cam : a data structure describing the recovered camera
%     x : the 2D coordinates of points in the image
%     X : the 3D "ground truth" coordinates of the points in the image
%
I = im2double(rgb2gray(imread(imfile)));

% get the grid corner points
fprintf('click on the corners in clockwise order starting from the upper left\n');
x = mapgrid(I);

% true 3D cooridnates (in cm) of the grid corners. this is only correct 
% assuming points were clicked in the order specified above
[yy,xx] = meshgrid(linspace(0,25.2,10),linspace(0,19.55,8));
zz = zeros(size(xx(:)));
X = [xx(:) yy(:) zz(:)]';

% now calibrate the camera

% initial guesses of parameters
%fprintf(size(I));
cy = size(I,1) / 2;
cx = size(I,2) / 2;
fmx = 1000;
% y-coordinates in MATLAB images are flipped (increasing as you go down
% in the image.  we represent this with a negative y magnification factor
fmy = -1000;
%guessing parameters, took a brute force attempt at guessing tx, ty, tz
%I got some nice results with 100,10,50 so I kept them
thx_guess = 0;
thy_guess = 0;
thz_guess = 0;
tx_guess = 100;
ty_guess = 10;
tz_guess = 50;

% build parameter vector

fixedparams = [cx;cy];
paramsinit = [fmx;fmy;thx_guess;thy_guess;thz_guess;tx_guess;ty_guess;tz_guess];

% setup the optimization routine 
opts = optimset('maxfunevals',100000,'maxiter',10000);
% use an anonymous function to capture fixedparams,X and x.
params_opt = lsqnonlin( @(params) project_error(params,fixedparams,X,x),paramsinit,[],[],opts);
% now unpack params_opt vector back into a cam struct.

cam.f = 1;
cam.m = [params_opt(1);params_opt(2)];
cam.c = [fixedparams(1);fixedparams(2)];
cam.R = rotation(params_opt(3),params_opt(4),params_opt(5));
cam.t = [params_opt(6);params_opt(7); params_opt(8)];

% lastly, plot the estimated projected locations of the 3D
%  points on top of the 2D image so we can visualize the 
% reprojection error
xest = project(X,cam);

figure(2); clf;
imagesc(I); axis image;
hold on;
plot(x(1,:),x(2,:),'b.')
plot(xest(1,:),xest(2,:),'r.')
hold off;
title('reprojections after optimization');

