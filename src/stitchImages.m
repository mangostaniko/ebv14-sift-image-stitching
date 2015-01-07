function [mosaic] = stitchImages( imA, imB, HBtoA, HAtoB, spline )
%% STITCHIMAGES3 Creates image mosaic 
%   Input: imA, imB ... m1xn1, m2xn2 images
%          HBtoA    ... 3x3 homography matrix s.t Hx2 = x1 (with hom. coords)
%          HAtoB    ... 3x3 homography matrix s.t Hx1 = x2 (with hom. coords)
%          spline   ... boolean, 'true' creates mosiac using multiresolution spline
%   Notation: x .. row index
%             y .. column index

%% Calculate mosaic size
[m1,n1,~] = size(imA);
[m2,n2,~] = size(imB);

% Transform corners of right image, corners = [A,B,C,D] with
% A .. left/above
% B .. right/above
% C .. right/below
% D .. left/below
corners = [1 1 m2 m2; 1 n2 n2 1; ones(1,4)];
cornersT = HBtoA*corners;
cornersT = round(cornersT(1:2,:)');
cornersTMin = min(cornersT);
cornersTMax = max(cornersT);

% Calculate image mosaic size
xyMin = min([cornersTMin;1 1]);
xyMax = max([cornersTMax;m1 n1]);
sizeMosaic = xyMax - xyMin + 1;

%% Shift to positive range (only necessary for x coords, as imB is right
% image)
shift = 0;
if xyMin(1)<1
    shift = -xyMin(1)+1;
    cornersT(:,1) = cornersT(:,1) +shift;
end

%% Extend imA to mosaic size
imAext = zeros([sizeMosaic,3]);
imAext((1+shift):(m1+shift),1:n1,:) = im2double(imA);

%% Transform imB

% Extend corners s.t. mask covers total area
extendCornersTX = cornersT(:,1)'+ [-1 -1 1 1];
extendCornersTY = cornersT(:,2)'+ [-1 1 1 -1];

% Create mask for transformed right picture in mosaic
% Mask defines mosaic region containg imB 
mask = poly2mask(extendCornersTY,extendCornersTX,sizeMosaic(1),sizeMosaic(2));
mask3 = cat(3,mask,mask,mask);

% Calculate corresponding coordinates in imB 
%       apply H to unshifted coordinates Tx
%       with translation matrix T
T = [1,0,-shift;0,1,0;0,0,1];
[coordsAX,coordsAY] = ind2sub(size(mask),find(mask>0));
coordsAtoB = HAtoB * T *[coordsAX'; coordsAY';ones(1, size(coordsAX,1))];
coordsAtoB = round(coordsAtoB(1:2,:)');
xAtoB = coordsAtoB(:,1); 
yAtoB = coordsAtoB(:,2); 

% Catch out of bound indices
xAtoB(xAtoB>m2) = m2;
xAtoB(xAtoB<1) = 1;
yAtoB(yAtoB>n2) = n2;
yAtoB(yAtoB<1) = 1;

% Write imB into mosaic
x = cat(3,xAtoB,xAtoB,xAtoB);
y = cat(3,yAtoB,yAtoB,yAtoB);
z = cat(3,ones(size(xAtoB)),2*ones(size(xAtoB)),3*ones(size(xAtoB)));
indAtoB = sub2ind([m2, n2, 3],x,y,z);
imBext = zeros([sizeMosaic,3]);
imBext(mask3)= im2double(imB(indAtoB));

%% Spline images: Multeresolution Spline
if spline
    %% Replicate edges along seem to avoid sharp edges during splining

    % Replicate values along the left seem
    edgeNodesX = [extendCornersTX(1),extendCornersTX(1),extendCornersTX(4),extendCornersTX(4)];
    edgeNodesY = [extendCornersTY(1),extendCornersTY(1)+1,extendCornersTY(4)+1,extendCornersTY(4)];
    imBext = replicateEdge(imBext, edgeNodesX, edgeNodesY, 10, 'left');

    % Replicate values along the top seem
    edgeNodesX = [extendCornersTX(1),extendCornersTX(2),extendCornersTX(2)+1,extendCornersTX(1)+1];
    edgeNodesY = [extendCornersTY(1),extendCornersTY(2),extendCornersTY(2),extendCornersTY(1)];
    imBext = replicateEdge(imBext, edgeNodesX, edgeNodesY, 10, 'up');

    % Replicate values along the bottom seem
    edgeNodesX = [extendCornersTX(4),extendCornersTX(3),extendCornersTX(3)-1,extendCornersTX(4)-1];
    edgeNodesY = [extendCornersTY(4),extendCornersTY(3),extendCornersTY(3),extendCornersTY(4)];
    imBext = replicateEdge(imBext, edgeNodesX, edgeNodesY, 10, 'down');
    
    %% Perform multiresolution spline
    mosaic = multiResSpline(imAext,imBext,mask);
    figure('name','mosaic: multiresolution spline');
    imshow(mosaic);
    
%% Spline images: Without multiresolution spline
else
    mosaic = (1-mask3).*imAext + mask3.*imBext;
    figure('name','mosaic: naive spline');
    imshow(mosaic);
    
end

end