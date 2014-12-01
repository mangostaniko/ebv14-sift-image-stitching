function [ leftovers ] = removeLowContrast( extrema, im )
% Author: Patrick Wahrmann
% input: extrema ... N*3-vector of N extrema points
%             im ... double intensity image (b/w) of keypoint scale
% output: leftovers ... extrema without low contrast

treshold = 0.02; %TODO: anpassen
pointer = 1;
leftovers = zeros(size(extrema));
for i = 1:size(extrema,1)
    x = extrema(i,1);
    y = extrema(i,2);
    l = extrema(i,3); %level of keypoint scale or so
    if x <= 1 || x >= size(im,1) || y <= 1 || y >= size(im,2)
        continue;
    end
    gradMagnitude = sqrt((im(x+1,y,l) - im(x-1,y,l))^2 + (im(x,y+1,l) - im(x,y-1,l))^2); %TODO: an format von im anpassen
 if gradMagnitude > treshold
     leftovers(pointer,:) = [x,y,l]; %DANGER: SLOW
     pointer = pointer+1;
 end
end

leftovers(sum((leftovers==0),2) ~= 0,:) = [];

end

