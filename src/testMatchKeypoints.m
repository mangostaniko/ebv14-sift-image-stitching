pos1 = rand(20,2);
pos2 = rand(25,2);

des1 = rand(20,128);
des2 = zeros(25,128);
indperm = randperm(20);
disp('perm'); disp(indperm);

for i=1:20
    des1(i,:)=des1(i,:)/norm(des1(i,:));
    des2(indperm(i),:)=des1(i,:);
end

matchKeypoints(pos1,pos2,des1,des2)