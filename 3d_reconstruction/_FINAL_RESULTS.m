%%%%%%%%% .PLY  %%%%%%%%%%%%%%%%%%%
figure(1); clf;
[tri, pts] = plyread('test.ply', 'tri');
h = trisurf(tri,pts(:,1),pts(:,2),pts(:,3)); 
%plot3(pts(:,1),pts(:,2),pts(:,3));
%surfnorm(tri);

%h = trisurf(tri,Y(1,:),Y(2,:),Y(3,:));
set(h,'edgecolor','flat')
axis image; axis vis3d;
camorbit(120,0); camlight left;
camorbit(120,0); camlight left;
lighting flat;
set(gca,'projection','perspective')
set(gcf,'renderer','opengl')
set(h,'facevertexcdata',xColor'/255);
material dull
