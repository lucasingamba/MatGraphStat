binaryY = [0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1];

for i=1:22
    cases{i} = mmread(strcat('~/adjacencyGraphs/graph', int2str(i),'.mtx'));
end 

sparseCase = ndSparse(cases{1});

for i=1:22
    sparseCase(:,:,i) = ndSparse(cases{i});
end


neareastNeighbors=10;

constraints{1}=NaN;         % use all edges
constraints{2}=round(neareastNeighbors/2);  % use best 5 edges
%constraints{3}=[1 neareastNeighbors-1];     % use best 5 edges incident to 1 vertex
%constraints{4}=[2 neareastNeighbors];       % use best 10 edges incident to 2 vertices

[Lhat incorrects subspace] = xval_SigSub_classifier(sparseCase, binaryY, constraints,'loo');
