function [ extrema ] = findExtrema( oct1, oct2, oct3, oct4 ) %, doubleSize
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
% if doubleSize
%     octaveExtrema1(:,1:2) = 0.5*octaveExtrema1(:,1:2);
%     octaveExtrema3(:,1:2) = 2*octaveExtrema3(:,1:2);
%     octaveExtrema4(:,1:2) = 4*octaveExtrema4(:,1:2);
% else
    octaveExtrema2(:,1:2) = 2*octaveExtrema2(:,1:2);
    octaveExtrema3(:,1:2) = 4*octaveExtrema3(:,1:2);
    octaveExtrema4(:,1:2) = 8*octaveExtrema4(:,1:2);
% end


%% Rounding
octaveExtrema1 = round(octaveExtrema1);
octaveExtrema2 = round(octaveExtrema2);
octaveExtrema3 = round(octaveExtrema3);
octaveExtrema4 = round(octaveExtrema4);


%% Adding extremas together
extrema = cat(1,octaveExtrema1,octaveExtrema2);
extrema = cat(1,extrema, octaveExtrema2);
extrema = cat(1,extrema, octaveExtrema3);
extrema = cat(1,extrema, octaveExtrema4);
end


function [extrema] = findExtremaPerOctave(dog)
withFilter = true; % else: with for loops
if withFilter
    extrema = findExtremaPerOctaveWithFilters(dog);
else
    extrema =  findExtremaPerOctaveWithForLoops(dog);
end
end


function [extrema] = findExtremaPerOctaveWithFilters(dog)


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
    maximaMatrix(:,:,z-1) = (ones(size(dog(:,:,1))) == 1);
    for i = 1:8
        sameLevelDog  = (dog(:,:,z) > imfilter(dog(:,:,z),filter(:,:,i), 'replicate'));
        lowerLevelDog = (dog(:,:,z) > imfilter(dog(:,:,z-1),filter(:,:,i), 'replicate'))+(dog(:,:,z)>dog(:,:,z-1))==2;
        upperLevelDog = (dog(:,:,z) > imfilter(dog(:,:,z+1),filter(:,:,i), 'replicate'))+(dog(:,:,z)>dog(:,:,z+1))==2;
        %add logical ones and check if all are true (i.e. sum is 4)
        maximaMatrix(:,:,z-1) = (maximaMatrix(:,:,z-1) + sameLevelDog + lowerLevelDog + upperLevelDog) == 4;
    end
end

% find minima
for z = 2:3 %only from center gauss levels
    minimaMatrix(:,:,z-1) = (ones(size(dog(:,:,1))) == 1);
    for i = 1:8
        sameLevelDog  = (dog(:,:,z) < imfilter(dog(:,:,z),filter(:,:,i), 'replicate'));
        lowerLevelDog = (dog(:,:,z) < imfilter(dog(:,:,z-1),filter(:,:,i), 'replicate'))+(dog(:,:,z)<dog(:,:,z-1))==2;
        upperLevelDog = (dog(:,:,z) < imfilter(dog(:,:,z+1),filter(:,:,i), 'replicate'))+(dog(:,:,z)<dog(:,:,z+1))==2;
        %add logical ones and check if all are true (i.e. sum is 4)
        minimaMatrix(:,:,z-1) = (minimaMatrix(:,:,z-1) + sameLevelDog + lowerLevelDog + upperLevelDog) == 4;
    end
end

extremaMatrix = (minimaMatrix + maximaMatrix) == 1; % minimaMatrix OR maximaMatrix
a1 = reshape(extremaMatrix(:,:,1),size(extremaMatrix(:,:,1),1),size(extremaMatrix(:,:,1),2));
[e2a,e2b] = find(a1==1); %Extract extrema coordinates (find ones)
extrema2 = cat(2,e2a,e2b);
a2 = reshape(extremaMatrix(:,:,2),size(extremaMatrix(:,:,2),1),size(extremaMatrix(:,:,2),2));
[e3a,e3b] = find(a2==1); %Extract extrema coordinates (find ones)
extrema3 = cat(2,e3a,e3b);

extrema2(:,3) = 2;
extrema3(:,3) = 3;

extrema = cat(1,extrema2,extrema3);



extrema = taylor(dog,extrema);


end

function [extrema] = taylor(dog,extrema)
%% Taylor approximation: (based on: https://dsp.stackexchange.com/questions/3382/approximating-pixel-location-in-scale-space/3386#3386)

taylorEnabled = true;


if taylorEnabled
    
    for i = 1:size(extrema,1) %for every extrema
        if extrema(1,1) == 0
            continue;
        end
        
        
        thisExtrema = extrema(i,:);
        x = thisExtrema(1);
        y = thisExtrema(2);
        level = thisExtrema(3);
        gx = (dog(x+1,y,level)-dog(x-1,y,level))/2;
        gy = (dog(x,y+1,level)-dog(x,y-1,level))/2;
        Hxx = dog(x+1,y,level)+dog(x-1,y,level)-2*dog(x,y,level);
        Hxy = (dog(x+1,y+1,level)+dog(x-1,y-1,level)-dog(x+1,y-1,level)-dog(x-1,y+1,level))/4;  % = Hyx
        Hyy = dog(x,y+1,level)+dog(x,y-1,level)-2*dog(x,y,level);
        H = [Hxx,Hxy;Hxy,Hyy];
        g = [gx;gy];
        delta = -(H\g); %(inv(H) *g)
        newPosX = x+delta(1);
        newPosY = y+delta(2);
        extrema(i,1)=newPosX;
        extrema(i,2)=newPosY;
    end
end
end

function [extrema] = findExtremaPerOctaveWithForLoops(dog)
imSizeX = size(dog,1);
imSizeY = size(dog,2);

extremaCounter = 0;
for z = 2:3 % the two middle level dog images are considered
    for x = 2:imSizeX-1 % all Pixels (without the borders)
        for y = 2:imSizeY-1
            
            maxCount = 0; % how many points are bigger than this one?
            minCount = 0; % how many points are smaller than this one?
            
            for upperLowerSame = -1:+1 % compare with upper, lower and the same level
                for dx = -1:+1 % compare points right, left and on the same x position
                    for dy = -1:+1 % compare points above, below and on the same y position
                        if (upperLowerSame ~= 0)||(dx~=0)||(dy~=0) %ensure that it is not compared with itself
                            if dog(x+dx,y+dy,z+upperLowerSame)>dog(x,y,z) % if the compared pixel is bigger than this one
                                maxCount = maxCount + 1; % increment the counter
                            end
                            if dog(x+dx,y+dy,z+upperLowerSame)<dog(x,y,z) % if the compared pixel is smaller than this one
                                minCount = minCount + 1; % increment the counter
                            end
                        end
                    end
                end
            end
            
            if (maxCount == 26 || minCount == 26) % if all compared pixels are bigger than this one: minimum, if all of them are smaller: maximum
                % extrema detected!
                extremaCounter = extremaCounter +1;
                extrema(extremaCounter,1) = x;
                extrema(extremaCounter,2) = y;
                extrema(extremaCounter,3) = z;
            end
            
        end
    end
end
if extremaCounter == 0
    extrema = zeros(0,3);
end
extrema = taylor(dog,extrema);
end
