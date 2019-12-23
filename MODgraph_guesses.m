function [G] = MODgraph_guesses(per_err_graphs,A_iter,D_iter,recons_siz,guess)
[err_graphs,indices] = sort(per_err_graphs);

D2  = D_iter(indices(guess),1:1:recons_siz(indices(guess))^2);
D2 = reshape(D2,[recons_siz(indices(guess)) recons_siz(indices(guess))]);

A2  = A_iter(indices(guess),1:1:recons_siz(indices(guess))^2);
A2 = reshape(A2,[recons_siz(indices(guess)) recons_siz(indices(guess))]);

G = graph(A2);
end