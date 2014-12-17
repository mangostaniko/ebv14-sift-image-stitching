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
    [normalizedSample,T1,T2] = normalizeSample(sample);
    HNormalized = fitSample(normalizedSample);
    H = inv(T2)*HNormalized*T1;
    
    % apply to all keypoints and count inliers
    Hx1 = H*[matches(:,1:2)';ones(1,length(matches))];
    Hx1_hom = Hx1(1:2,:)./repmat(Hx1(3,:),2,1);
    dist = sum((Hx1_hom-matches(:,3:4)').^2,1);
    inliers = length(find(dist<tol)); 
    
    if (inliers>maxInliers)
        HBest = H;
        maxInliers = inliers
        sample
    end
    
end

end



