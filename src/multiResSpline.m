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
    
    % create laplacian pyramids
    LA = createLoG(imA);
    LB = createLoG(imB);
    LM = createLoG(mask);
    
    LS = struct(LA);
    
    % spline each pyramid level separatly
    for j=1:4
        LS(j).scale = (1-LM(j).scale).*LA(j).scale + LM(j).scale.*LB(j).scale;
    end
    
    % reconstruct image
    mosaic(:,:,i) = expand(expand(expand(LA(4).scale)+LA(3).scale)+LA(2).scale)+LA(1).scale;
    

end

end

