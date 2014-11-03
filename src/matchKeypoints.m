function [ matches ] = matchKeypoints( pos1, pos2, descr1, descr2 )
%% MATCHKEYPOINTS  finds corresponding keypoint matches for two keypoint lists given their positions and SIFT descriptors
% Author: Hanna Huber
% input:     pos1 ... N1*2 vector of keypoint positions (image1)
%            pos2 ... N2*2 vector of keypoint positions (image2)
%          descr1 ... N1*128 vector of SIFT keypoint descriptors (image1)
%          descr2 ... N2*128 vector of SIFT keypoint descriptors (image2)
% output: matches ... N*4 matrix of matched keypoints
%%

n = size(descr1,1);
descr2T = descr2';
threshold = 0.5;
matches = zeros(n,4);
matchInd = zeros(n,1);
matchDist = zeros(n,1);

% iterate over all keypoints of image1
for i=1:n
    
    % compute distance to all keypoints of image2 and choose closest
    phi = acos(descr1(i,:)*descr2T);
    phi_sort = sort(phi);
    dist = phi_sort(1);
    ind = find(phi==dist);
    
    % only accept distinct choices
    if (dist < phi_sort(2)*threshold)
        
        % check if keypoint has been chosen before
        sameInd = find(matchInd==ind);
        if(length(sameInd)==0)
            matchInd(i) = ind;
            matchDist(i) = dist;
            
        % accept if new match is better and remove old match
        elseif (dist < matchDist(sameInd))
            matchInd(i) = ind;
            matchDist(i) = dist;
            matchInd(sameInd) = 0;
            matchDist(sameInd) = 0;
        end
        
    end
        
end

matchInd=nonzeros(matchInd);
firstInd = matchInd~=0;
disp('matchInd'); disp(matchInd);
matches(1:length(matchInd),1:2) = pos1(firstInd,:);
matches(1:length(matchInd),3:4) = pos2(matchInd,:);



end

