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