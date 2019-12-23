function [h] = plot_heatmap(variance_mea)
%Written By Pengwah Abu
%ID: 27195139
%Description: This function will plot the heatmap for a given structure
%containing the discretized distance matrices and the pairwise distances
%Input: variance_mea structure containg the discretized values of distances
%output the returned graph plot
for i = 1:length(variance_mea.ind)
    Varmatrix(variance_mea.ind(i,1),variance_mea.ind(i,2)) = variance_mea.variance_mea(i);
    Varmatrix(variance_mea.ind(i,2),variance_mea.ind(i,1)) = variance_mea.variance_mea(i);
end
 
% xvals = join(string(variance_mea.ind),",");
% xvals = (cellstr(xvals))';
% [r,c] = size(variance_mea.D_discrete);
h = heatmap(Varmatrix);
h.Title = 'Variance of Pairwise Hop Counts'
h.XLabel = 'Node IDs'
h.YLabel = 'Node IDs'
h.Colormap = jet;
end

