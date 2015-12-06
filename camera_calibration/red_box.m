fprintf('click on 4 corner points (in standard order)\n');
I = imread('left_box.jpg');
I_gray = rgb2gray(I); 
axis image;
colormap('gray');
imagesc(I_gray);
xL1 = ginput(1);
hold on;
plot(xL1(1,1), xL1(1,2), '.r');
%hold on;
xL2 = ginput(1);
hold on;
plot(xL2(1,1), xL2(1,2), '.r');
xL3 = ginput(1);
hold on;
plot(xL3(1,1), xL3(1,2), '.r');
%hold on;
xL4 = ginput(1);
hold on;
plot(xL4(1,1), xL4(1,2), '.r');

xL = [xL1;xL2;xL3;xL4];
xL_t = xL';

fprintf('click on 4 corner points (in standard order)\n');
I = imread('right_box.jpg');
I_gray = rgb2gray(I); 
axis image;
colormap('gray');
imagesc(I_gray);
xR1 = ginput(1);
hold on;
plot(xR1(1,1), xR1(1,2), '.r');
%hold on;
xR2 = ginput(1);
hold on;
plot(xR2(1,1), xR2(1,2), '.r');
xR3 = ginput(1);
hold on;
plot(xR3(1,1), xR3(1,2), '.r');
%hold on;
xR4 = ginput(1);
hold on;
plot(xR4(1,1), xR4(1,2), '.r');

xR = [xL1;xL2;xL3;xL4];
xR_t = xR';
% initial guesses of parameters

camL.f = 1;
camR.f = 1;
camL.m = [1000;1000];
camR.m = [1000;1000];
camL.c = [50;50];
camR.c = [50;50];
camL.R= [1 0 0; 0 1 0; 0 0 1];
camL.t = [0;0;0];
camR.t= [2;0;0];
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
Xest = triangulate(xL_t,xR_t,camL,camR);
figure(1); clf;
hold on;
plot3(Xest(1,:),Xest(2,:),Xest(3,:),'r.')
