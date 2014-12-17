function [H] = fitSample(sample)
% Calculates homography matrix that fits sample
% Input: sample .. n-by-4 matrix containing matches in normalized coordinates,  sample(i) = (p1',p2')
% Output: H .. 3-by-3 matrix H satisfying p2_hom = H*p1_hom
    
    sampleSize = size(sample,1);
    A = zeros(sampleSize*2,9);
    for k = 1:sampleSize
       A(2*k-1,:)   = [-sample(k,1:2),-1,0,0,0,[sample(k,1:2),1]*sample(k,3)];
       A(2*k,:) = [0,0,0,-sample(k,1:2),-1,[sample(k,1:2),1]*sample(k,4)];
    end
    
%      [U,S,V] = svd(A);
%     h = V(:,end);
%     H = reshape(h, [3 3]);
    [V,~] = eig(A'*A);
    H = reshape(V(:,1),[3,3])';
    H = H/H(end); % make H(3,3) = 1


end
