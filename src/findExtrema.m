function [ extrema ] = findExtrema( oct1, oct2, oct3, oct4 )
% Author: Patrick Wahrmann
% input: oct1 (4 Images), oct2 (4 Images), oct3 (4 Images), oct4 (4 Images) ... complete DoG pyramid
% output: extrema ...  N*3-vector of N extrema points (x,y,frequency level(1-7))




%% getting the extrema per octave:
octaveExtrema1 = findExtremaPerOctave(oct1);
octaveExtrema2 = findExtremaPerOctave(oct2);
octaveExtrema3 = findExtremaPerOctave(oct3);
octaveExtrema4 = findExtremaPerOctave(oct4);

%% on which frequency level was the extremum found?
octaveExtrema2(:,3) = octaveExtrema2(:,3)+1;
octaveExtrema3(:,3) = octaveExtrema3(:,3)+2;
octaveExtrema4(:,3) = octaveExtrema4(:,3)+3;

%% Interpolating Pixels of different octaves
octaveExtrema2(:,1:2) = 2*octaveExtrema2(:,1:2);
octaveExtrema3(:,1:2) = 4*octaveExtrema3(:,1:2);
octaveExtrema4(:,1:2) = 8*octaveExtrema4(:,1:2);

%% Adding extremas together
extrema = cat(1,octaveExtrema1,octaveExtrema2);
extrema = cat(1,extrema, octaveExtrema2);
extrema = cat(1,extrema, octaveExtrema3);
extrema = cat(1,extrema, octaveExtrema4);
end



function [extrema] = findExtremaPerOctave(oct)

%Finding vertical (different frequency levels) extrema:
% diff(1) = (oct(2) > oct(1)) && (oct(2)> oct(3));
% diff(2) = (oct(3) > oct(2)) && (oct(3)> oct(4));
% 
% verticalExtrema(1) = oct(2).*diff(1);
% verticalExtrema(2) = oct(3).*diff(2);

%Finding horizontal extrema
%Warning: Inefficient for-loops:
%    for x = -1:+1
%        for y = -1:+1
%            horizontalExtrema(1) = oct(2) > oct(2,:+x,:+y);
%        end
%    end

%Trick für Performance: Filter anwenden, der Bild quasi in eine Richtung
%verschiebt. Dann vergleichen und falls größer == true
filter = zeros(3,3,8);
filter(:,:,1)=[1,0,0;0,0,0;0,0,0];
filter(:,:,2)=[0,1,0;0,0,0;0,0,0];
filter(:,:,3)=[0,0,1;0,0,0;0,0,0];
filter(:,:,4)=[0,0,0;1,0,0;0,0,0];
filter(:,:,5)=[0,0,0;0,0,1;0,0,0];
filter(:,:,6)=[0,0,0;0,0,0;1,0,0];
filter(:,:,7)=[0,0,0;0,0,0;0,1,0];
filter(:,:,8)=[0,0,0;0,0,0;0,0,1];


for z = 2:3
    extremaMatrix(:,:,z-1) = (ones(size(oct(:,:,1))) == 1);
    for i = 1:8
        sameLevelDog  = (oct(:,:,z) > imfilter(oct(:,:,z),filter(:,:,i)));
        lowerLevelDog = (oct(:,:,z) > imfilter(oct(:,:,z-1),filter(:,:,i)));
        upperLevelDog = (oct(:,:,z) > imfilter(oct(:,:,z+1),filter(:,:,i)));
        %add logical ones and check if all are true (i.e. sum is 4)
        extremaMatrix(:,:,z-1) = (extremaMatrix(:,:,z-1) + sameLevelDog + lowerLevelDog + upperLevelDog) == 4;
    end
end

%Comparing vertical to horizontal Extrema:
%extremaMatrix(1) = horizontalExtrema(1) && verticalExtrema(1);
%extremaMatrix(2) = horizontalExtrema(2) && verticalExtrema(2);


%extremaMatrix(3) = extremaMatrix(1) || extremaMatrix(2);
% 
% pointer = 1;
% for x = 2:size(extremaMatrix(3),1)-1 %borders not considered because they can't be extrema
%    for y = 2:size(extremaMatrix(3),2)-1
%         if(extremaMatrix(3,x,y))
%            extrema(pointer,1) = x; %Consider allocating before the loop for speed? Size unknown.
%            extrema(pointer,2) = y;
%            pointer = pointer +1;
%         end
%    end
% end
a1 = reshape(extremaMatrix(1,:,:),size(extremaMatrix(1,:,:),2),size(extremaMatrix(1,:,:),3));
[e2a,e2b] = find(a1==1); %Extract extrema coordinates (find ones)
extrema2 = cat(2,e2a,e2b);
a2 = reshape(extremaMatrix(2,:,:),size(extremaMatrix(2,:,:),2),size(extremaMatrix(2,:,:),3));
[e3a,e3b] = find(a2==1); %Extract extrema coordinates (find ones)
extrema3 = cat(2,e3a,e3b);
%TODO index out of bound? --> initialize earlier? Dont know N ...
extrema2(:,3) = 2; %TODO: check indices
extrema3(:,3) = 3;

extrema = cat(1,extrema2,extrema3);
end