function [iter_err] = cmpTrueGraph(err_mea,Back,no_leaf,Dtrue)
%Written By Pengwah Abu Bakr Siddique
%ID: 27195139
%Decription: This function will take as input the error measurements and
%the backtracking results as well as the true_graph discretized for the
%leaf nodes
%OUTPUT: A structure with all the error metrics stored
if (~isempty(Back.A_iter))
    [r,c] = size(Back.A_iter);
else
    r=0;c=0;
end
if (~isempty(Back.A_iter))
    %get the graph with the minimum error of PROFILING
    G1 = MODgraph_guesses(err_mea.Vprofile,Back.A_iter,Back.D_iter,Back.recons_siz,1);
    Dleaf = distances(G1); % discretize the graph
    Dleaf = Dleaf(2:no_leaf+1,2:no_leaf+1); %only Leaf Nodes
    iter_err.firstguess = norm(Dleaf - Dtrue,'fro'); %norm of the difference between the matrices
    %get the graph with the minimum error of OBJECTIVE
    [~,ind] = min(err_mea.obj);
    scriptvar.A  = Back.A_iter(ind,1:1:Back.recons_siz(ind)^2);
    scriptvar.A = reshape(scriptvar.A,[Back.recons_siz(ind) Back.recons_siz(ind)]);
    G = graph(scriptvar.A);Dleaf = distances(G);
    Dleaf = Dleaf(2:no_leaf+1,2:no_leaf+1);
    iter_err.obj = norm(Dleaf - Dtrue,'fro');
    %get the graph with the minimum error of PRODUCT OF PROFILING AND
    %OBJECTIVE
    [~,ind] = min(err_mea.merProfobj);
    scriptvar.A  = Back.A_iter(ind,1:1:Back.recons_siz(ind)^2);
    scriptvar.A = reshape(scriptvar.A,[Back.recons_siz(ind) Back.recons_siz(ind)]);
    G = graph(scriptvar.A);Dleaf = distances(G);
    Dleaf = Dleaf(2:no_leaf+1,2:no_leaf+1);
    iter_err.merProfobj = norm(Dleaf - Dtrue,'fro');
    %get the graph with the minimum error of: Profiling and voltage Measurements
    [~,ind] = min(err_mea.merProfVmag);
    scriptvar.A  = Back.A_iter(ind,1:1:Back.recons_siz(ind)^2);
    scriptvar.A = reshape(scriptvar.A,[Back.recons_siz(ind) Back.recons_siz(ind)]);
    G = graph(scriptvar.A);Dleaf = distances(G);
    Dleaf = Dleaf(2:no_leaf+1,2:no_leaf+1);
    iter_err.merProfVmag = norm(Dleaf - Dtrue,'fro');
    %Voltage measurements Comparison
    [~,ind] = min(err_mea.V_err_graphs);
    scriptvar.A  = Back.A_iter(ind,1:1:Back.recons_siz(ind)^2);
    scriptvar.A = reshape(scriptvar.A,[Back.recons_siz(ind) Back.recons_siz(ind)]);
    G = graph(scriptvar.A);Dleaf = distances(G);
    Dleaf = Dleaf(2:no_leaf+1,2:no_leaf+1);
    iter_err.Vmag = norm(Dleaf - Dtrue,'fro');
else
    iter_err.firstguess = NaN;
    iter_err.obj = NaN;
    iter_err.merProfobj = NaN;
    iter_err.merProfVmag = NaN;
    iter_err.Vmag = NaN;
end
%SECOND BEST GUESS
if (r>=2)
    G2 = MODgraph_guesses(err_mea.Vprofile,Back.A_iter,Back.D_iter,Back.recons_siz,2);
    Dleaf = distances(G2); Dleaf = Dleaf(2:no_leaf+1,2:no_leaf+1);
    iter_err.guess2 = norm(Dleaf - Dtrue,'fro');
else
    iter_err.guess2 = NaN;
end
end

