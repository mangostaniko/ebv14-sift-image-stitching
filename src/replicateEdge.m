function [ image ] = replicateEdge( image, edgeNodesX, edgeNodesY, width, direction )
%% REPLICATEEDGE replicates the edge of a rgb image width times in the respective direction 
%    author: Hanna Huber
%    input: image      ... mxn rgb image
%           edgeNodesX ... 1x4 vector of row indices of the points defining the edge
%                          in cw or ccw order
%                          e. g. for an edge between the points p1, p2:
%                          [x1, x1 +/- 1, x2 +/- 1, x2] if direction is 'up' or 'down'
%                          [x1, x1, x2, x2]             if direction is 'left' or 'right'
%           edgeNodesY ... 1x4 vector of column indices of the points defining the edge
%                          in cw or ccw order
%                          for an edge between the points p1, p2:
%                          [y1, y1, y2, y2]  if direction is 'up' or 'down'
%                          [y1, y1 +/- 1, y2 +/- 1, y2]      if direction is 'left' or 'right'
%           width      ... positive integer, number of replications of the edge
%           direction  ... direction of replication: 'left', 'right', 'up' or 'down'
%   output: image      ... original image with replicated edge

%% determine edge indices

[m,n,~] = size(image);

% create 2D mask
edgeMask = poly2mask(edgeNodesY, edgeNodesX, m, n);

% calculate subscripts corresponding to edge
[rows,cols] = ind2sub([m n],find(edgeMask));

% calculate replication of linear indices
% necessary, because values to be assigned to extended region must be same size as region
z = cat(3,ones(size(cols,1),width),2*ones(size(cols,1),width),3*ones(size(cols,1),width));
edge = sub2ind([m,n,3],repmat(rows,[1,width,3]),repmat(cols,[1,width,3]),z);

%% define extended region in resp. direction
%   define shift matrix
%   shift rows/colums
%   catch out-of-bound indices
%   calculate corresponding linear indices

switch direction
    case 'left'
        shift = repmat(-width:1:-1,[size(cols,1),1]);   
        extendedCols = shift+repmat(cols,[1,width]);
        extendedCols(extendedCols<1)=1;
        extendedEdge = sub2ind([m,n,3],repmat(rows,[1,width,3]),repmat(extendedCols,[1,1,3]),z);
    case 'right'
        shift = repmat(1:width,[size(cols,1),1]); 
        extendedCols = shift+repmat(cols,[1,width]);
        extendedCols(extendedCols>n)=n;
        extendedEdge = sub2ind([m,n,3],repmat(rows,[1,width,3]),repmat(extendedCols,[1,1,3]),z);
    case 'up'
        shift = repmat(-width:1:-1,[size(rows,1),1]); 
        extendedRows = shift+repmat(rows,[1,width]);
        extendedRows(extendedRows<1)=1;
        extendedEdge = sub2ind([m,n,3],repmat(extendedRows,[1,1,3]),repmat(cols,[1,width,3]),z);
    case 'down'
        shift = repmat(1:width,[size(rows,1),1]); 
        extendedRows = shift+repmat(rows,[1,width]);
        extendedRows(extendedRows>m)=m;
        extendedEdge = sub2ind([m,n,3],repmat(extendedRows,[1,1,3]),repmat(cols,[1,width,3]),z);
end

%% assign image values to extended region
image(extendedEdge) = image(edge);

end

