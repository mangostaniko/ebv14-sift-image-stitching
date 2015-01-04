function [] = stitchImages3( imA, imB, HBtoA, HAtoB )
%STITCHIMAGES3 Creates image mosaic 
%   Input: imA, imB ... m1xn1, m2xn2 images
%          H        ... 3x3 homography matrix s.t Hx2 = x1 (with hom. coords)
%          H        ... 3x3 homography matrix s.t Hx1 = x2 (with hom. coords)
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

% Calculate corresponding coordinates in imB
[coordsAX,coordsAY] =  ind2sub(size(mask),find(mask>0));
coordsAtoB = HAtoB * [coordsAX'; coordsAY';ones(1, size(coordsAX,1))];
coordsAtoB = round(coordsAtoB(1:2,:)');

xAtoB = reshape((coordsAtoB(:,1)),n2,m2)';
yAtoB = reshape((coordsAtoB(:,2)),n2,m2)';

% Write imB into mosaic
indAtoB = sub2ind([m2, n2],xAtoB,yAtoB);
imBext = zeros([sizeMosaic,3]);
imBext(mask,:)= im2double(imB(indAtoB,:));

figure('name','imAext');
imshow(imAext);
figure('name','imBext');
imshow(imBext);
figure('name','mask');
imshow(mask);

end