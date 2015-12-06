[camL,xL,XtrueL] = calibrate('C:/Users/Roula/Documents/MATLAB/Assignment_4/left_calib.jpg');
[camR,xR,XtrueR] = calibrate('C:/Users/Roula/Documents/MATLAB/Assignment_4/right_calib.jpg');

imageprefix = 'C:/Users/Roula/Documents/MATLAB/Assignment_4/left/left/left_';
imageprefix2 = 'C:/Users/Roula/Documents/MATLAB/Assignment_4/right/right/right_';
threshold = 5;
start = 1;
stop = 20;
[Lh_C,Lh_goodpixels] = decode(imageprefix,start,stop,threshold);
[Rh_C,Rh_goodpixels] = decode(imageprefix2,start,stop,threshold);

start = 20;
stop = 40;
[Lv_C,Lv_goodpixels] = decode(imageprefix,start,stop,threshold);
[Rv_C,Rv_goodpixels] = decode(imageprefix2,start,stop,threshold);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%given
w = 1632;
h = 1224;
[xx,yy] = meshgrid(1:w,1:h); %create arrays containing the pixel coordinates

R_C = Rh_C + 1024*Rv_C;%????%turn the horizontal and vertical codes into a single pixel index
L_C = Lh_C + 1024*Lv_C;%????
R_goodpixels = Rh_goodpixels & Rv_goodpixels;%????
L_goodpixels = Lh_goodpixels & Lv_goodpixels;%????
R_sub = find(R_goodpixels);     % find the indicies of pixels which were succesfully decoded
L_sub = find(L_goodpixels);

%intersect these sets to find those of pixels that were good in both the left and right images
[matched,iR,iL] = intersect(R_C(R_sub),L_C(L_sub));
[a,b] = size(iR);
[c,d] = size(iL);

xR2(1,:) = xx(R_sub(iR(:)));  % pull out the x,y coordinates of those matched pixels
xR2(2,:) = yy(R_sub(iR(:)));
xL2(1,:) = xx(L_sub(iL(:)));
xL2(2,:) = yy(L_sub(iL(:)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = triangulate(xL2,xR2,camL,camR);
Xx = X(1,:)/X(3,:);
Xy =X(2,:)/X(3,:);
Xz = X(3,:);
plot3(Xx, Xy, Xz);



