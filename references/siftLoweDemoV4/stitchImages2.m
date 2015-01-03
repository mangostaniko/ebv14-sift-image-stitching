function [] = stitchImages2( imA, imB, H )
%STITCHIMAGES2 Creates image mosaic 
%   Input: imA, imB ... m1xn1, m2xn2 images
%          H        ... 3x3 homography matrix s.t Hx2 = x1 (with hom. coords)
%   Notation: x .. row index
%             y .. column index

[m1,n1] = size(imA);
[m2,n2] = size(imB);

% Transform corners of right image
corners = [1 m2 1 m2; 1 1 n2 n2; ones(1,4)];
cornersT = H*corners;
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
imAext = zeros(sizeMosaic);
imAext((1+shift):(m1+shift),1:n1) = im2double(imA);

% Transform imB to imA coordinate system
[xB, yB] = meshgrid(1:m2, 1:n2);
coordsB = [xB(:) yB(:)]';
coordsBtoA = H * [coordsB; ones(1, m2*n2)];
coordsBtoA = (coordsBtoA(1:2,:))'; % ./repmat(coordsBtoA(3,:),2,1)
xBtoA = reshape(round(coordsBtoA(:,1)),n2,m2)'+shift;
yBtoA = reshape(round(coordsBtoA(:,2)),n2,m2)';

% Extend transformed imB to mosiac size
imBext = zeros(sizeMosaic);
indB = sub2ind([m2, n2],xB',yB');
indBtoA = sub2ind(sizeMosaic,xBtoA,yBtoA);
imBext(indBtoA) = im2double(imB(indB));

% Create mask
mask = imBext>0;

figure('name','imAext');
imshow(imAext);
figure('name','imBext');
imshow(imBext);
figure('name','mask');
imshow(mask);
% Create laplace pyramides for imAext, imBext, mask

% % Klim version
% scaleSpaceA = scaleSpace(imAext,4,1);
% scaleSpaceB = scaleSpace(imBext,4,1);
% scaleSpaceM = scaleSpace(mask,4,1);
% LA = calculateDog(scaleSpaceA{1});
% LB = calculateDog(scaleSpaceB{1});
% LM = calculateDog(scaleSpaceM{1});

% EBV B4 version
[ oct1, oct2, oct3, oct4, dog1, dog2, dog3, dog4 ] = createDoG2( imAext, false, false );

imshow(dog1(:,:,1));


end

