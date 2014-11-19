pos1 = rand(20,2);
pos2 = rand(25,2);

des1 = rand(20,128);
des2 = zeros(25,128);
indperm = randperm(20);
%disp('perm'); disp(indperm);

for i=1:20
    des1(i,:)=des1(i,:)/norm(des1(i,:));
    des2(indperm(i),:)=des1(i,:);
end

matches = matchKeypoints(pos1,pos2,des1,des2)

H = findHomography(matches)
Hx1 = H*[matches(:,1:2)';ones(1,20)]
Hx1_hom = Hx1(1:2,:)./repmat(Hx1(3,:),2,1)
x2 = matches(:,3:4)'

