%
% This script tests the project function.
% You may want to modify it to try other tests and/or cut
% and paste bits into your interactive MATLAB session as 
% you are debugging.
%


%
% first generate our test figure in 3D
%
X = generate_hemisphere(2,[0;0;10],1000);

%
% set intrinsic parameters shared by both cameras
%

%focal length
camL.f = 1;
camR.f = 1;

%pixel magnification factor
camL.m = [100;100];
camR.m = [100;100];

%location of camera center
camL.c = [50;50];
camR.c = [50;50];

%
% extrinsic params for left camera
%
camL.R= [1 0 0; 0 1 0; 0 0 1];
camL.t = [0;0;0];

%
%extrinsic params for right camera
%
camR.t= [0.5;0;0];

% rotate the right camera towards the left camera (counter-clockwise
% around the y axis) so that it is looking toward the center of the
% point cloud.  

% We will choose the angle based on the translation so that the sphere
% stays centered in the camera
thy = atan2(camR.t(1),10); 
Ry = [  cos(thy)   0  -sin(thy) ; ...
              0    1         0 ; ...
       sin(thy)   0  cos(thy) ];
thz = 0;
Rz = [  cos(thz) -sin(thz) 0 ; ...
       sin(thz) cos(thz) 0 ; ...
               0        0 1 ];
thx = 0;
Rx = [ 1 0 0 ; ...
       0 cos(thx) -sin(thx) ; ...
       0 sin(thx) cos(thx) ];
% compose the three rotations.
camR.R = Rx*Rz*Ry;

%
% now compute the two projections
%
xL= project(X,camL);

xR = project(X,camR);
%fprintf('\n%f', xL);
%fprintf('\n%f', xR);
%
% display results
%
figure(1); clf;

subplot(1,2,1);
plot(xL(1,:),xL(2,:),'b.')
axis image; axis([0 100 0 100]);
grid on;
title('left camera image');

subplot(1,2,2);
plot(xR(1,:),xR(2,:),'b.')
axis image; axis([0 100 0 100]);
grid on;
title('right camera image');
