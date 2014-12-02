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
        maxInliers = inliers;
    end
    
end

end

function [H] = fitSample(sample)
    
    sampleSize = size(sample,1);
    A = zeros(sampleSize*2,9);
    for k = 1:sampleSize
       A(2*k-1,:)   = [-sample(k,1:2),-1,0,0,0,[sample(k,1:2),1]*sample(k,3)];
       A(2*k,:) = [0,0,0,-sample(k,1:2),-1,[sample(k,1:2),1]*sample(k,4)];
    end
    
     [U,S,V] = svd(A);
    h = V(:,end);
    H = reshape(h, [3 3]);

end

function [T] = normalizationMatrix(x)
% Performs normalization for normalized DLT

    % Translate x s.t. mean(x)=0
    tx = -mean(x(1,:));
    ty = -mean(x(2,:));
    T_trans = [1,0,tx;0,1,ty;0,0,1];
    
    x_trans = T_trans*x;
   
    % Scale x s.t. mean(|x|)=sqrt(2)
    l = sqrt(sum(x_trans(1:2,:).^2));
    s = sqrt(2)/mean(l);
    T_scale = [s,0,0;0,s,0;0,0,1];
    T = T_scale*T_trans;

end

function[normalizedSample,T1,T2] = normalizeSample(sample)
% Normalizes sample using normalizationMatrix()
% Input: n-by-4 matrix with sample(i,:)=(x1,y1,x2,y2)
% Output: sample with normalized coordinates and normalizing matrices

    x1 = [sample(:,1:2)';ones(1,size(sample,1))];
    x2 = [sample(:,3:4)';ones(1,size(sample,1))];
    
    T1 = normalizationMatrix(x1);
    T2 = normalizationMatrix(x2);
    T1x1 = (T1*x1)';
    T2x2 = (T2*x2)';
    normalizedSample = [T1x1(:,1:2),T2x2(:,1:2)];
    

end

