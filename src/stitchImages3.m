function [mosaic] = stitchImages3( imA, imB, HBtoA, HAtoB, spline )
%STITCHIMAGES3 Creates image mosaic 
%   Input: imA, imB ... m1xn1, m2xn2 images
%          HBtoA    ... 3x3 homography matrix s.t Hx2 = x1 (with hom. coords)
%          HAtoB    ... 3x3 homography matrix s.t Hx1 = x2 (with hom. coords)
%          spline   ... boolean, 'true' creates mosiac using multiresolution spline
%   Notation: x .. row index
%             y .. column index

[m1,n1,~] = size(imA);
[m2,n2,~] = size(imB);

% Transform corners of right image, corners = [A,B,C,D] with
% A .. left/above
% B .. right/above
% C .. right/below
% D .. left/below
corners = [1 1 m2 m2; 1 n2 n2 1; ones(1,4)];
cornersT = HBtoA*corners;
cornersT = cornersT(1:2,:)';
cornersTMin = round(min(cornersT));
cornersTMax = round(max(cornersT));

% Calculate image mosaic size
yxMin = min([cornersTMin;1 1]);
yxMax = max([cornersTMax;m1 n1]);
sizeMosaic = yxMax - yxMin + 1;

% Shift to positive range (only necessary for x coords, as imB is right
% image)
shift = 0;
if yxMin(1)<1
    shift = -yxMin(1)+1;
end

% Extend imA to mosaic size
imAext = zeros([sizeMosaic,3]);
imAext((1+shift):(m1+shift),1:n1,:) = im2double(imA);

% Extend corners s.t. mask covers totla area
extendCornersTX = cornersT(:,1)'+ [-1 -1 1 1];
extendCornersTY = cornersT(:,2)'+ [-1 1 1 -1];


% Create mask for transformed right picture in mosaic
mask = poly2mask(extendCornersTY,extendCornersTX,sizeMosaic(1),sizeMosaic(2));
mask3 = cat(3,mask,mask,mask);

% Calculate corresponding coordinates in imB
[coordsAX,coordsAY] =  ind2sub(size(mask),find(mask>0));
coordsAtoB = HAtoB * [coordsAX'; coordsAY';ones(1, size(coordsAX,1))];
coordsAtoB = round(coordsAtoB(1:2,:)');
%rows = length(unique(coordsAtoB(:,1)));
%cols = size(coordsAtoB,1)/rows; %length(unique(coordsAtoB(:,2)));
xAtoB = coordsAtoB(:,1); %reshape((),cols,rows)';
yAtoB = coordsAtoB(:,2); %reshape((),cols,rows)';

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

figure('name','imAext');
imshow(imAext);
figure('name','imBext');
imshow(imBext);
figure('name','mask');
imshow(mask);

% perform multiresolution spline
if spline
    
% without multiresolution spline
else
    mosaic = (1-mask3).*imAext + mask3.*imBext;
    figure('name','mosaic');
    imshow(mosaic);
    
end

end