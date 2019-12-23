function [Gd,Ad] = create_directed(A,G)
% Creates a directed Graph from an undirected one
%Start traversing from substation to leaf
Ad = A;
Ad(:) = 0;
Ad(:,1)=0;
Ad(1,:) = A(1,:);
for i = 2:length(A)
    [P] = shortestpath(G,1,i);
    for j=2:length(P)-1
        Ad(P(j),P(j+1)) = 1;
    end
end
Gd=digraph(Ad);
end

