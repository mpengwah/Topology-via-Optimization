function [err_mea] = Topology_Check(Back,scriptvar,no_leaf,length_profile)
%Written By Pengwah Abu
% ID:27195139
% Description: This Function will use the results of backtracking to infer
% the closest topology matching the 'true topology'
%INPUTS: Back ; Contains all the results of backtracking (ITS a struct)
% scriptvar: contains the voltages/current measurements (ITS a struct)
% no_leaf: numberof leaf nodes
%length_profile: the number of measurements to be used on the Backward
%forward sweep method
%Outputs:
%err_mea: a structure containing different error measurements
%-------
%Starts HERE:
[scriptvar.r,scriptvar.c] = size(Back.A_iter); %All Possible Scenarios
Back.Vnom = 240; %Slack Bus Voltage
BFopt.verbose=0; %Suppress Printng to console
ratio = 2; %Use a fix R/X ratio
for iter = 1:scriptvar.r
    %--Reconstruct the graphs and distances matrices
    scriptvar.A  = Back.A_iter(iter,1:1:Back.recons_siz(iter)^2);
    scriptvar.A = reshape(scriptvar.A,[Back.recons_siz(iter) Back.recons_siz(iter)]);
    scriptvar.Dlf_resis = Back.D_iter(iter,1:1:Back.recons_siz(iter)^2);
    scriptvar.Dlf_resis = (reshape(scriptvar.Dlf_resis,[Back.recons_siz(iter) Back.recons_siz(iter)]));
    scriptvar.Dlf_react = Back.Dreact_iter(iter,1:1:Back.recons_siz(iter)^2);
    scriptvar.Dlf_react = abs(reshape(scriptvar.Dlf_react,[Back.recons_siz(iter) Back.recons_siz(iter)]));
    %----
    if (scriptvar.Dlf_resis(:)>=0)
        scriptvar.G = graph(scriptvar.A);
        %----------------------------
        %sensitvity back into optimization
        [Sr,Sx] = topo_to_sensi(scriptvar.A,scriptvar.Dlf_resis,scriptvar.Dlf_react,no_leaf);
        S = [Sr Sx];
        err_mea.obj(iter)=norm(S*scriptvar.Ax - scriptvar.v,'fro');
        %----------------------------
        %Keep a fix R/X ratio
        scriptvar.Dlf_react = scriptvar.Dlf_resis / ratio;
        %----------------
        %REORDERING TREE
        [scriptvar.An,scriptvar.Gn,scriptvar.Dn,scriptvar.Dnreact,scriptvar.F...
            ,scriptvar.renum,scriptvar.leaf_nodesN] = tree_ordering(scriptvar.A...
            ,scriptvar.G,scriptvar.Dlf_resis,scriptvar.Dlf_react,no_leaf);
        for i =1:length(scriptvar.V(:,1:length_profile))
            [mpc] = create_caseFB(scriptvar.An,scriptvar.Dn,scriptvar.Dnreact,scriptvar.F,scriptvar.renum,scriptvar.leaf_nodesN,scriptvar.I(:,i),scriptvar.pf(:,i));
            [LF_results,success] = runBF_LF(mpc,Back.Vnom,BFopt);
            if (success==1)
                Vleaf_nodes(:,i) = LF_results.bus(scriptvar.leaf_nodesN,8);
                VBF(:,i) = LF_results.bus(:,8);
                Verr(:,i) = abs(scriptvar.V(:,i) - Vleaf_nodes(:,i))./scriptvar.V(:,i) * 100;
            else
                Verr(:,i) = NaN;
                Vleaf_nodes(:,i) =NaN;
                VBF(:,i) = NaN;
            end
        end
        [test_profile_allnodes] = voltage_profile(Vleaf_nodes);
        err_mea.Vprofile(iter) = norm(Back.AllTrueProf - test_profile_allnodes,'fro');
        err_mea.V_err_graphs(iter) = mean(mean(Verr,2,'omitnan'));
        err_mea.merProfobj(iter) = err_mea.Vprofile(iter) * err_mea.obj(iter);
        err_mea.merProfVmag(iter)  = err_mea.Vprofile(iter) * err_mea.V_err_graphs(iter);
        Verr = [];VBF = []; Vleaf_nodes=[];
    else
        err_mea.V_err_graphs(iter) = NaN;
        err_mea.Vprofile(iter) = NaN;
        err_mea.obj(iter) = NaN;
        err_mea.merProfobj(iter) = NaN;
        err_mea.merProfVmag(iter) = NaN;
    end
end
end

