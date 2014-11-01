function [ extrema ] = findExtrema( oct1, oct2, oct3, oct4 )
% Author: Patrick Wahrmann
% input: oct1 (4 Images), oct2 (4 Images), oct3 (4 Images), oct4 (4 Images) ... complete DoG pyramid
% output: extrema ...  N*2-vector of N extrema points


octaveExtrema(1) = findExtremaPerOctave(oct1);
octaveExtrema(2) = findExtremaPerOctave(oct2);
octaveExtrema(3) = findExtremaPerOctave(oct3);
octaveExtrema(4) = findExtremaPerOctave(oct4);

% Simply add Extrema of all octaves together?
extrema = cat(1,octaveExtrema(1),octaveExtrema(2));
extrema = cat(1,extrema, octaveExtrema(2));
extrema = cat(1,extrema, octaveExtrema(3));
extrema = cat(1,extrema, octaveExtrema(4));
end

function [extrema] = findExtremaPerOctave(oct)
%Finding vertical extrema:
diff(1) = (oct(2) > oct(1)) && (oct(2)> oct(3));
diff(2) = (oct(3) > oct(2)) && (oct(3)> oct(4));

verticalExtrema(1) = oct(2).*diff(1);
verticalExtrema(2) = oct(3).*diff(2);

%Finding horizontal extrema
%Warning: Inefficient for-loops:
%    for x = -1:+1
%        for y = -1+1
%            horizontalExtrema(1) = oct(2) > oct(2,:+x,:+y);
%        end
%    end

%Trick für Performance: Filter anwenden, der Bild quasi in eine Richtung
%verschiebt. Dann vergleichen und falls größer = true
filter(1)=[1,0,0;0,0,0;0,0,0];
filter(2)=[0,1,0;0,0,0;0,0,0];
filter(3)=[0,0,1;0,0,0;0,0,0];
filter(4)=[0,0,0;1,0,0;0,0,0];
filter(5)=[0,0,0;0,0,1;0,0,0];
filter(6)=[0,0,0;0,0,0;1,0,0];
filter(7)=[0,0,0;0,0,0;0,1,0];
filter(8)=[0,0,0;0,0,0;0,0,1];

for z = 2:3
    horizontalExtrema(z-1) = ones(size(oct,2)*size(oct,3)); %TODO check if Dimensions are right   
    for i = 1:8
        horizontalExtrema(z-1) = horizontalExtrema && (oct(z) > imfilter(oct(z),filter(i)));
    end
end

%Comparing vertical to horizontal Extrema:
extremaMatrix(1) = horizontalExtrema(1) && verticalExtrema(1);
extremaMatrix(2) = horizontalExtrema(2) && verticalExtrema(2);

% How to choose Extrema? I take them from both relevant Octaves
extremaMatrix(3) = extremaMatrix(1) || extremaMatrix(2);

pointer = 1;
for x = 2:size(extremaMatrix(3),1)-1 %borders not considered because the can't be extrema
   for y = 2:size(extremaMatrix(3),2)-1
        if(extremaMatrix(3,x,y))
           extrema(pointer,1) = x; %Consider allocating before the loop for speed? Size unknown.
           extrema(pointer,2) = y;
           pointer = pointer +1;
        end
   end
end
end