function outputs = fastTestOutputEdges(As, ys)

mean0 = mean(As(:,:,ys.y0),3);
mean1 = mean(As(:,:,ys.y1),3);


meanDiff= abs(mean0-mean1);

maxMeanDiff = max(meanDiff);

mm =max(maxMeanDiff,[],2);

[i,j] = find(meanDiff==mm);

outputs = [i,j];
