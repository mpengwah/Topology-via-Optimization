function [variance_mea,ind,d_discrete] = variance_calc(Back)
%Writtten By Pengwah Abu Bakr
%ID: 27195139
[r,c] = size(Back.D_iter);
vec = 1;
for i=1:r
    A  = Back.A_iter(i,1:1:Back.recons_siz(i)^2);
    A = reshape(A,[Back.recons_siz(i) Back.recons_siz(i)]);
    D_temp  = Back.D_iter(i,1:1:Back.recons_siz(i)^2);
    D_temp = reshape(D_temp,[Back.recons_siz(i) Back.recons_siz(i)]);
    if (D_temp(:)>=0)
        %normalized distances
        G = graph(A);
        D = distances(G);
        D = D(2:Back.leaf_node+1,2:Back.leaf_node+1);
        D_discrete(vec,:) = reshape(D,[1 length(D)^2]);
        vec = vec + 1;
    end
end

Tr = (1:Back.leaf_node^2)';
Tr = reshape(Tr,[Back.leaf_node Back.leaf_node]);
Tr = triu(Tr);
Variance_mea = var(D_discrete);
vec = 1;

for i=1:length(Tr)
    for j = i+1:length(Tr)
        variance_mea(vec) = Variance_mea(Tr(i,j));
        d_discrete(:,vec) = D_discrete(:,Tr(i,j));
        ind(vec,:) = [i j];
        vec = vec + 1;
    end
end
end

