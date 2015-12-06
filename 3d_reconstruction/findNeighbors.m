neighbourbhood = findNeighbors(vertex, tri, X)

% neighbourbhood = findNeighbors(vertex, tri, X)
% given a vertex, it will find all those other shared
% points with this vertex in tri/X
%
%
% outputs: returns an 3xN matrix

[m,n] = size(vertex);


for i=1:m
    indices = find(tri,vertex(i));
end

[m,n] = size(tri);
nbrs = zeros(3,size(indices));
for i=1:m
    %for j=1:n
       nbrs(:,i) = X(:,indices(i));
   % end
end


