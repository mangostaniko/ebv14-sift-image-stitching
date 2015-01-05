function [ mosaic ] = multiResSpline( imArgb, imBrgb, mask )
%MULITRESSPLINE Blends images using multiresolution spline
%   Input: imA, imB ... mxn or mxnx3 images to be splined
%          mask     ... mxn logical image
%                       mask=1 for pixels that are taken from imB
%                       mask=0 for pixels that are taken from imA


mosaic = zeros(size(imArgb));

% perform splining for each color channel separately
for i=1:size(imArgb,3)
    imA = imArgb(:,:,i);
    imB = imBrgb(:,:,i);
    
    % create laplacian pyramids of the images to be splined
    LA = createLoG(imA);
    LB = createLoG(imB);
    
    % create gaussian pyramid of the mask
    GM = createGaussPyr(mask);
    
    LS = struct(LA);
    
    % spline each pyramid level separatly
    for j=1:4
        LS(j).scale = (1-GM(j).scale).*LA(j).scale + GM(j).scale.*LB(j).scale;
    end
    
    % reconstruct image
    log4to3 = imresize(LS(4).scale,size(LS(3).scale),'bilinear')+LS(3).scale;
    log3to2 = imresize(log4to3,size(LS(2).scale),'bilinear')+LS(2).scale;
    mosaic(:,:,i) = imresize(log3to2,size(LS(1).scale),'bilinear')+LS(1).scale;  

end

end

