function meanDiff = fastTest(As, ys)

mean0 = mean(As(:,:,ys==0),3);
mean1 = mean(As(:,:,ys==1),3);


meanDiff= abs(mean0-mean1);

