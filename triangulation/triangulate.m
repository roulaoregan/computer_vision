
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
%

if (size(xL,2) ~= size(xR,2))
  error('must have same number of points in left and right images');
end

npts = size(xL,2);

% first convert from pixel coordinates back into 
% meters with unit focal length
xLm(1,:) = (xL(1,:) - camL.c(1)) / (camL.f * camL.m(1));
xLm(2,:) = (xL(2,:) - camL.c(2)) / (camL.f * camL.m(2));
xLm(3,:) = 1;

xRm(1,:) = (xR(1,:) - camR.c(1)) / (camR.f * camR.m(1));
xRm(2,:) = (xR(2,:) - camR.c(2)) / (camR.f * camR.m(2));
xRm(3,:) = 1;

%
% make the left camera the origin of the world
% coordinate system by transforming both cameras
% appropriately
%
R = inv(camL.R);
t = -camL.t;
camRL.R = R*camR.R;
camRL.t = R*(camR.t + t);
camLL.R = R*camL.R;
camLL.t = R*(camL.t + t);

%
% for now assume that camL is at the origin.
% express xLm in the right camera coordinate system
%
xLmR = inv(camRL.R)*xLm;
tR = -inv(camRL.R)*repmat(camRL.t,1,npts);

% now solve the equation:
% 
%   Z_r * xRm = Z_l * xLmR + tR
%
% for the Zs
%
Z_r = zeros(1,npts);
Z_l = zeros(1,npts);
for i = 1:npts
  A = [xRm(:,i) -xLmR(:,i)];
  Z = inv(A'*A)*A'*tR(:,i);
  Z_r(i) = Z(1);
  Z_l(i) = Z(2);
  fprintf('\r %d/%d',i,npts);
end

%compute coordinates in left camera ref frame
XL = [Z_l;Z_l;Z_l].*[xLm(1:2,:);ones(1,npts)];
XR = [Z_r;Z_r;Z_r].*[xRm(1:2,:);ones(1,npts)];

%finally map X back to world coordinates 
Xa = camL.R*XL + repmat(camL.t,1,npts);
Xb = camR.R*XR + repmat(camR.t,1,npts);

X = 0.5*(Xa+Xb);


