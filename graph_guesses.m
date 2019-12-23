function [h2] = graph_guesses(per_err_graphs,A_iter,D_iter,recons_siz,guess)
[err_graphs,indices] = sort(per_err_graphs);

D2  = D_iter(indices(guess),1:1:recons_siz(indices(guess))^2);
D2 = reshape(D2,[recons_siz(indices(guess)) recons_siz(indices(guess))]);

A2  = A_iter(indices(guess),1:1:recons_siz(indices(guess))^2);
A2 = reshape(A2,[recons_siz(indices(guess)) recons_siz(indices(guess))]);

G = graph(A2);
g_edges = G.Edges.EndNodes;
linearidx = sub2ind(size(D2),g_edges(:,1), g_edges(:,2));
g_weights = D2(linearidx);
G.Edges.Weight = g_weights;

idname = string(1:length(A2)-1);
idname = ["S" idname];
figure;
h2 = plot(G,'NodeLabel',idname,'EdgeLabel',G.Edges.Weight);
highlight(h2,1,'NodeColor','r','MarkerSize',15,'NodeFontSize',12)
if (guess == 1)
    str = sprintf('Via Backtracking - BEST GUESS ; Error in LF = %.3f',err_graphs(guess));
else
    str = sprintf('Via Backtracking - Guess Number %d ; Error in LF = %.3f',guess,err_graphs(guess));
end
title(str);
grid on
set(gca,'FontSize',14)
end