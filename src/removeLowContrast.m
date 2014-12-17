function [ leftovers ] = removeLowContrast( extrema, oct )
% Author: Patrick Wahrmann
% input: extrema ... N*3-vector of N extrema points (x,y,frequency)
%             im ... double intensity image (b/w) of keypoint scale
%             NOTE: internal image representation (octA) where x are rows and y are columns! (x, y)
% output: leftovers ... extrema without low contrast

treshold = 0.02; %TODO: anpassen
pointer = 1;
leftovers = zeros(size(extrema));
for i = 1:size(extrema,1)
    x = extrema(i,1);
    y = extrema(i,2);
    l = extrema(i,3); % keypoint frequency level
    if x <= 1 || x >= size(oct,1) || y <= 1 || y >= size(oct,2)
        continue;
    end
    gradMagnitude = sqrt((oct(x+1,y,l) - oct(x-1,y,l))^2 + (oct(x,y+1,l) - oct(x,y-1,l))^2);
 if gradMagnitude > treshold
     leftovers(pointer,:) = [x,y,l]; %NOTE: SLOW
     pointer = pointer+1;
 end
end

leftovers(sum((leftovers==0),2) ~= 0,:) = [];

end

