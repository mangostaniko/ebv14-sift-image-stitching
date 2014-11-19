function [ leftovers ] = removeLowContrast( extrema, im )
% Author: Patrick Wahrmann
% input: extrema ... N*3-vector of N extrema points
%             im ... double intensity image (b/w) of keypoint scale
% output: leftovers ... extrema without low contrast

treshhold = 10; %TODO: anpassen
pointer = 1;
for i = 1:size(extrema,1)
    x = extrema(i,1);
    y = extrema(i,2);
    l = extrema(i,3); %level of keypoint scale or so
 gradMagnitude = sqrt((im(l,x+1,y) - im(l,x-1,y))^2 + (im(l,x,y+1) - im(l,x,y-1))^2); %TODO: an format von im anpassen
 if gradMagnitude > treshhold
     leftovers(pointer) = [x,y,l]; %DANGER: SLOW
     pointer = pointer+1;
 end 
end
end

