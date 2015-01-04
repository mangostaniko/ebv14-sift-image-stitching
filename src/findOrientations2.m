function [ keypointOrientations ] = findOrientations2( keypoints, octaves, sigmas )
%% FINDORIENTATIONS 2 finds keypoint orientation (most prominent gradient among neighboring pixels)
% Author: Nikolaus Leopold
% input:     keypoints ... N*3-vector of keypoints (x, y, frequency level)
%              octaves ... cell array of all 4 octaves/resolutions of double grayscale image
%                          each at all 5 frequency/gaussblur levels
%                          NOTE: internal representation where x are rows
%                          and y are columns! access using {octave}(x, y, blurLvl)
%               sigmas ... sigmas ... sigma values used for each of the 5 blur levels
% output: keypointOrientations ... keypoint orientations in radian [0, 2pi]
%
% NOTE: the original findOrientations actually works better so use it
% instead !!
%%

BIN_COUNT = 36;
BIN_SIZE = 2*pi/BIN_COUNT; % bin size in radian

% find gradients (direction of greatest change) and 
% store their orientations and magnitudes for all octaves and blur levels
gradients = cell(size(octaves,2),size(octaves{1},3),2); % gradients{octave}{blurLvl}{1=orientation, 2=magnitude}

% use filter to efficiently get orientation and magnitude matrices
for octave = 1:size(octaves,2)
    for blurLvl = 1:size(octaves{1},3)

        % gradient orientation is: atan2((im(x,y+1) - im(x,y-1)), (im(x+1,y) - im(x-1,y)));
        % however atan2 results are in [-pi, pi], so needs to be mapped to [0, 2pi]
        %
        % gradient magnitude is: sqrt((im(x,y+1) - im(x,y-1))^2 + (im(x+1,y) - im(x-1,y))^2);
        
        %filter kernel for delta x (im(x+1,y) - im(x-1,y)): 
        kernelDeltaX = [0 0 0; -1 0 1; 0 0 0];
        deltaXMat = imfilter(octaves{octave}(:,:,blurLvl), kernelDeltaX);

        %filter kernel for delta y (im(x,y+1) - im(x,y-1)): 
        kernelDeltaY = [0 1 0; 0 0 0; 0 -1 0];
        deltaYMat = imfilter(octaves{octave}(:,:,blurLvl), kernelDeltaY);

        %get gradient magnitude and orientation matrices for this octave and blur
        gradOrientationMat = atan2(deltaYMat, deltaXMat);
        gradOrientationMat(gradOrientationMat <= 0) = 2*pi + gradOrientationMat(gradOrientationMat <= 0); % map to [0, 2pi]

        gradMagnitudeMat = sqrt(deltaXMat.*deltaXMat + deltaYMat.*deltaYMat);

        %store magnitude and orientation matrices
        gradients{octave}{blurLvl}{1} = gradOrientationMat; 
        gradients{octave}{blurLvl}{2} = gradMagnitudeMat; 

    end 
end 

% for each keypoint create histogram of gradient magnitudes binned by orientation
% to find dominant gradient in sample window around keypoint.
% gradient magnitudes are collected in sample window around keypoint
% and added up in bins according to their gradient orientation, 
% with gaussian weighting around keypoint applied to magnitudes
for k = 1:size(keypoints,1)
    
    keypointBlurLvl = keypoints(k,3);
    octave = 1;
    
    % according to Lowe, sigma of 1.5 * sigma of keypoint blurLvl should be
    % used for gaussian weight distribution of magnitudes around keypoint
    sigma = sigmas(keypointBlurLvl)*1.5;
    windowSize = round(sigma*6-1); % size of sample window depends on sigma too
    weightKernel = fspecial('gaussian',[windowSize windowSize], sigma);

    octaveHeight = size(octaves{octave},1);
    octaveWidth  = size(octaves{octave},2);

    % find start and end positions of sample window
    startX = round(keypoints(k,1) - windowSize/2); 
    endX =   round(keypoints(k,1) + windowSize/2 - 1);
    startY = round(keypoints(k,2) - windowSize/2); 
    endY =   round(keypoints(k,2) + windowSize/2 - 1);

        % check index bounds adjust sample window and weight kernel if necessary
        kernelTruncateXMin = 0; 
        kernelTruncateXMax = 0; 
        kernelTruncateYMin = 0; 
        kernelTruncateYMax = 0;

        if (startX < 1) 
            startX = 1; 
            kernelTruncateXMin = windowSize-(endX-startX)-1; 
        end 

        if (startY < 1)
            startY = 1;
            kernelTruncateYMin = windowSize-(endY-startY)-1; 
        end 

        if (endX > octaveHeight)
            endX = octaveHeight; 
            kernelTruncateXMax = windowSize - kernelTruncateXMin-(endX-startX+1); 
        end 

        if (endY > octaveWidth)
            endY = octaveWidth; 
            kernelTruncateYMax = windowSize - kernelTruncateYMin-(endY-startY+1); 
        end 

        % adjust kernel size to octave bounds by truncating as necessary
        weightKernel = weightKernel((1+kernelTruncateXMin):(size(weightKernel,1)-kernelTruncateXMax),  ...
            (1+kernelTruncateYMin):(size(weightKernel,2)-kernelTruncateYMax));
    
        % normalize kernel to [0, 1] again
        kernelMax = max(max(weightKernel));
        weightKernel = weightKernel.*(1/kernelMax);
      

    % get magnitudes from gradient magnitude matrix that lie within sample window
    magnitudes = gradients{octave}{keypointBlurLvl}{1}(startX:endX,startY:endY);

    % apply weight kernel to magnitudes
    magnitudes = magnitudes.*weightKernel;                     

    % get orientations from gradient orientation matrix that lie within sample window
    orientations = gradients{octave}{keypointBlurLvl}{2}(startX:endX,startY:endY);
    
        
    histogram = zeros(BIN_COUNT, 1); % magnitudes binned by orientation

    % add magnitudes to histogram bin of corresponding orientation
    for (x = 1:size(orientations,1))
        for (y = 1:size(orientations,2))
            binIndices(x,y) = ceil(orientations(x,y)./BIN_SIZE + 0.001); % in range [1, 36]
            histogram(binIndices(x,y)) = histogram(binIndices(x,y)) + magnitudes(x,y);
        end
    end

    % the bin with greatest magnitude is our keypoint orientation (use median bin orientation)
    greatestBin = find(histogram == max(histogram));
    keypointOrientations(k) = ( (greatestBin-1)*BIN_SIZE + (greatestBin)*BIN_SIZE ) / 2;
    
    
end


end

