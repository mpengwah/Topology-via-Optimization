function [A_iter,D_iter,Dreact_iter,recons_siz,leaf_node] = ...
    remove_seriesNodes(A_iter,D_iter,Dreact_iter,recons_siz,leaf_node)
%Written By Pengwah Abu
%This Function applies a strict constraint on the graphs returned whereby
%we remove the topologies where the lead nodes are parent and child instead
%of siblings
[r,c] = size(A_iter);
for iter = 1:r
    A  = A_iter(iter,1:1:recons_siz(iter)^2);
    A = reshape(A,[recons_siz(iter) recons_siz(iter)]);
    %find instances where leaf node is an intermediate node
    for i=2:leaf_node+1
        if (sum(A(i,:))>1)
            A_iter(iter,:) = NaN;
            D_iter(iter,:)=NaN;
            Dreact_iter(iter,:)=NaN;
            recons_siz(iter)=NaN;
        end
    end
end
tf = isnan(A_iter);
tf = find(sum(tf,2)==c);
A_iter(tf,:) = [];
D_iter(tf,:)=[];
Dreact_iter(tf,:)=[];
recons_siz(tf)=[];
end

