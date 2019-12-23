function [Sr,Sx] = topo_to_sensi(A,Dresis,Dreact,no_leaf)
%This function will take as input the parameters of the unidirected graph
%such as adjacency matrix, resistance and reactance matrices plus the
%number of leaf nodes.
%It will output the new sensitvity matrix
%TAke note that the first entry of the Dresis/Dreact is the slack bus entry
%Sensitvity for Resistance
G = graph(A);
g_edges = G.Edges.EndNodes;
linearidx = sub2ind(size(Dresis),g_edges(:,1), g_edges(:,2));
g_weights = Dresis(linearidx);
G.Edges.Weight = g_weights;

for i = 1:no_leaf
    [~,d] = shortestpath(G,1,i+1);
    Sr(i,i) = d;
end
Dleaf = Dresis(2:no_leaf+1,2:no_leaf+1);
for i=1:length(Sr)
    for j=i+1:length(Sr)
        Sr(i,j) = 0.5*(Sr(i,i) + Sr(j,j) - Dleaf(i,j));
        Sr(j,i) = Sr(i,j);
    end
end
%reactance values
g_edges = G.Edges.EndNodes;
linearidx = sub2ind(size(Dreact),g_edges(:,1), g_edges(:,2));
g_weights = Dreact(linearidx);
G.Edges.Weight = g_weights;

for i = 1:no_leaf
    [~,d] = shortestpath(G,1,i+1);
    Sx(i,i) = d;
end
Dleaf = Dreact(2:no_leaf+1,2:no_leaf+1);
for i=1:length(Sx)
    for j=i+1:length(Sx)
        Sx(i,j) = 0.5*(Sx(i,i) + Sx(j,j) - Dleaf(i,j));
        Sx(j,i) = Sx(i,j);
    end
end

end

