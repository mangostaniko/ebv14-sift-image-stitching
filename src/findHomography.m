function [ HBest ] = findHomography( matches )
%% Author: Hanna Huber
%  input: matches ... keypoints matches
%  output:      H ... homography matrix (determinded using RANSAC)
%% DISCUSS: 
% number of iterations
% number of randomly selected matches
% tol --> projected distance? d=(Hx1-x29^2+(Hy1+y2)^2
% include minimal number of inliers?

% define number of iterations and number of randomly selected matches
iterations = 10000; 
sampleSize = 4;
tol = 10^(-2);

maxInliers = 0;


for i = 1:iterations
    
    % fit random sample
    sample = datasample(matches,sampleSize, 1, 'Replace', false);
    H = fitSample(sample);
    
    % apply to all keypoints and count inliers
    Hx1 = H*[matches(:,1:2)';ones(1,length(matches))];
    Hx1_hom = Hx1(1:2,:)./repmat(Hx1(3,:),2,1);
    dist = sum((Hx1_hom-matches(:,3:4)').^2,1);
    inliers = length(find(dist<tol)); 
    
    if (inliers>maxInliers)
        HBest = H;
        maxInliers = inliers;
    end
    
end

end

function [H] = fitSample(sample)
    
    sampleSize = size(sample,1);
    A = zeros(sampleSize*2,9);
    for k = 1:sampleSize
       A(k,:)   = [-sample(k,1:2),-1,0,0,0,[sample(k,1:2),1]*sample(k,3)];
       A(k+1,:) = [0,0,0,-sample(k,1:2),-1,[sample(k,1:2),1]*sample(k,4)];
    end
    
    [U,S,V] = svd(A);
    h = V(:,end);
    H = reshape(h, [3 3]);

end

