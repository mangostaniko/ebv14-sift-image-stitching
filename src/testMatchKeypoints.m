pos1 = randi([1 1000], 20,2);
pos2 = zeros(20,2);
HTest = [2,0,0;0,3,0;0,0,1]*[1,0,50;0,1,20;0,0,1]; %*[0,-1,0;1,0,0;0,0,1];  test with S*T (*R)
% pos2 = HTest*[pos1';ones(1,20)]
% pos2 = (pos2(1:2,:)./repmat(pos2(3,:),2,1))';

des1 = rand(20,128);
des2 = zeros(25,128);
indperm = randperm(20);
%disp('perm'); disp(indperm);

for i=1:20
    des1(i,:)=des1(i,:)/norm(des1(i,:));
    des2(indperm(i),:)=des1(i,:);
    Hx1 = HTest*[pos1(i,:)';1];
    pos2(indperm(i),:)= Hx1(1:2)';
end

matches = matchKeypoints(pos1,pos2,des1,des2)

H = findHomography(matches)
Hx1 = H*[matches(:,1:2)';ones(1,20)]
Hx1_hom = Hx1(1:2,:)./repmat(Hx1(3,:),2,1)
x2 = matches(:,3:4)'

