function [ image ] = replicateEdge( image, edgeNodesX, edgeNodesY, width, direction )
%replicateEdge replicates the edge of a rgb image width times in the repsective direction 

[m,n,~] = size(image);

% Create 2D mask
edgeMask = poly2mask(edgeNodesY, edgeNodesX, m, n);

% Calculate subscripts
[rows,cols] = ind2sub([m n],find(edgeMask));
z = cat(3,ones(size(cols,1),width),2*ones(size(cols,1),width),3*ones(size(cols,1),width));
edge = sub2ind([m,n,3],repmat(rows,1,width,3),repmat(cols,1,width,3),z);
switch direction
    case 'left'
        shift =repmat(-width:1:-1,size(cols,1),1);   
        extendedCols = shift+repmat(cols,1,width);
        extendedCols(extendedCols<1)=1;
        extendedEdge = sub2ind([m,n,3],repmat(rows,1,width,3),repmat(extendedCols,1,1,3),z);
    case 'right'
        shift =repmat(1:width,size(cols,1),1); 
        extendedCols = shift+repmat(cols,1,width);
        extendedCols(extendedCols>n)=n;
        extendedEdge = sub2ind([m,n,3],repmat(rows,1,width,3),repmat(extendedCols,1,1,3),z);
    case 'up'
        shift =repmat(-width:1:-1,size(rows,1),1); 
        extendedRows = shift+repmat(rows,1,width);
        extendedRows(extendedRows<1)=1;
        extendedEdge = sub2ind([m,n,3],repmat(extendedRows,1,1,3),repmat(cols,1,width,3),z);
    case 'down'
        shift =repmat(1:width,size(rows,1),1); 
        extendedRows = shift+repmat(rows,1,width);
        extendedRows(extendedRows>m)=m;
        extendedEdge = sub2ind([m,n,3],repmat(extendedRows,1,1,3),repmat(cols,1,width,3),z);
end

image(extendedEdge) = image(edge);

end

