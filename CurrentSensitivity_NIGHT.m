clc;clear all
%All Measurements
data = load ('nightdata.mat');
load true_graphv3;
for phase = 1:3
    switch(phase)
        case(1) %phase A
            fprintf('Phase A\n');
            scriptvar.pf = data.PFa;
            scriptvar.V = data.Va;
            scriptvar.I = data.Ia;
            scriptvar.pfcheck = data.PFa;
            scriptvar.idplot = data.idA;
            [no_leaf,scriptvar.data_length] = size(scriptvar.V);
            %for quadrants
            quadrant.segsize = floor((scriptvar.data_length - 1)/4);
        case(2)%phase B
            fprintf('Phase B\n');
            %Known from the currentsensitivity_daynight.m file
            % Use constant nodes to keep results comparable
            scriptvar.row = [11;16;17];
            
            scriptvar.pf = data.PFb;
            scriptvar.V = data.Vb;
            scriptvar.I = data.Ib;
            scriptvar.idB = data.idB;
            
            scriptvar.pf(scriptvar.row,:)=[];
            scriptvar.V(scriptvar.row,:) = [];
            scriptvar.I(scriptvar.row,:) =[];
            scriptvar.idB(scriptvar.row)=[];
            scriptvar.pfcheck = scriptvar.pf;
            scriptvar.idplot = scriptvar.idB;
            [no_leaf,scriptvar.data_length] = size(scriptvar.V);
            %for quadrants
            quadrant.segsize = floor((scriptvar.data_length - 1)/4);
        case(3)
            fprintf('Phase C\n');
            %Known from the currentsensitivity_daynight.m file
            % Use constant nodes to keep results comparable
            scriptvar.row = [9;11;12;13;15;16;17;21];
            
            scriptvar.pf = data.PFc;
            scriptvar.V = data.Vc;
            scriptvar.I = data.Ic;
            scriptvar.idC = data.idC;
            
            scriptvar.pf(scriptvar.row,:)=[];
            scriptvar.V(scriptvar.row,:) = [];
            scriptvar.I(scriptvar.row,:) =[];
            scriptvar.idC(scriptvar.row)=[];
            scriptvar.idplot = scriptvar.idC;
            scriptvar.pfcheck = scriptvar.pf;
            [no_leaf,scriptvar.data_length] = size(scriptvar.V);
            %for quadrants
            quadrant.segsize = floor((scriptvar.data_length - 1)/4);
    end
    for iteration_number = 1:4
        fprintf('Quadrant Number: %d\n',iteration_number);
        %Starting and ending point of window
        scriptvar.st = 1 + quadrant.segsize * (iteration_number - 1);
        scriptvar.fin = scriptvar.st + quadrant.segsize;
        %--
        scriptvar.pf = abs(scriptvar.pf);
        scriptvar.pf = scriptvar.pf .* sign(scriptvar.I);
        check =isnan(scriptvar.pf);
        [r,c] = find(check==1);
        c = unique(c);
        scriptvar.pf(:,c)=[];
        scriptvar.V(:,c)=[];
        scriptvar.I(:,c)=[];
        scriptvar.pfcheck(:,c)=[];
        scriptvar.I = abs(scriptvar.I);
        scriptvar.theta = acos(scriptvar.pf);
        scriptvar.theta = scriptvar.theta .* sign(scriptvar.pfcheck);
        %---------
        %Consecutive Time Differences
        Ireal = real(scriptvar.I .* exp(1j*scriptvar.theta));
        Iimag = imag(scriptvar.I.* exp(1j*scriptvar.theta));
        
        ir = diff(Ireal(:,scriptvar.st:scriptvar.fin),1,2);
        scriptvar.v = diff(scriptvar.V(:,scriptvar.st:scriptvar.fin),1,2);
        iimag = diff(Iimag(:,scriptvar.st:scriptvar.fin),1,2);
        
        scriptvar.Ax = [ir;iimag];
        scriptvar.Xx = scriptvar.Ax;
        [scriptvar.r,scriptvar.c]=size(scriptvar.Xx);
        %-------------------------
        [scriptvar.A,scriptvar.b,scriptvar.Aeq,scriptvar.beq,scriptvar.Aineq,scriptvar.bineq]...
            = constraints_reactance(scriptvar.r,scriptvar.c,scriptvar.Xx,scriptvar.v);
        %-------------------------
        %CONSTRAINTS
        x=sdpvar(2*(scriptvar.r/2)^2,1);
        C = [x(:)<=0,scriptvar.Aeq * x == scriptvar.beq,scriptvar.Aineq * x <= scriptvar.bineq];
        % DISTANCE INEQUALITY
        [C] = constraint_distance_inequality_withreactance(scriptvar.r,x,C);
        %--------------------------------------------------------------------------
        %OBJECTIVE FUNCTION
        %MINIMIZE THE L-2 NORM OF THE RESIDUALS IN YALMIP
        residuals = scriptvar.A*x - scriptvar.b;
        obj = norm(residuals,2);
        %SOLVING THE OPT PROBLEM
        options = sdpsettings('verbose',0,'solver','mosek');
        sol = optimize(C,obj,options);
        scriptvar.n = scriptvar.r/2;
        Opt.Sir = extract_symmetricvals(value(x),scriptvar.n,1);
        Opt.Six = extract_symmetricvals(value(x),scriptvar.n,2);
        LS_exp.Sexpre = scriptvar.A\scriptvar.b;
        LS_exp.Sir_expre = extract_symmetricvals(LS_exp.Sexpre,scriptvar.n,1);
        LS_exp.Six_expre = extract_symmetricvals(LS_exp.Sexpre,scriptvar.n,2);
        clear sol options obj x residuals C
        Opt.Dor = distance_matrix(Opt.Sir);
        Opt.Dreactance = distance_matrix(Opt.Six);
        [Opt.D,Opt.Adjace,Opt.G,Opt.Dreact] = RG_ALGO(Opt.Dor,Opt.Dreactance);
        %Analytical Expression Result
        LS_exp.Dor = distance_matrix(LS_exp.Sir_expre);
        LS_exp.Dreactance = distance_matrix(LS_exp.Six_expre);
        [LS_exp.D,LS_exp.A,LS_exp.G,LS_exp.Dreact] = RG_ALGO(LS_exp.Dor,LS_exp.Dreactance);
        
        scriptvar.idname = string(1:length(LS_exp.A)-1);
        scriptvar.idname = ["S" scriptvar.idname];
        %--------------------------------------------------------------------------
        %% Backtracking
        Back.Dor = distance_matrix(Opt.Sir);
        Back.Dreactance = distance_matrix(Opt.Six);
        fprintf('Entered BackTracking\n')
        [Back.A_iterOR,Back.D_iterOR,Back.recons_sizOR,Back.Dreact_iterOR] = BackTrackv2(Back.Dor,Back.Dreactance,no_leaf);
        fprintf('BackTracking Completed\n')
        %--------------------------------------------------------------------------
        
        %% Remove Series Nodes - Strict Constraint
        [Back.A_iter,Back.D_iter,Back.Dreact_iter,Back.recons_siz,Back.leaf_node] = ...
            remove_seriesNodes(Back.A_iterOR,Back.D_iterOR,Back.Dreact_iterOR,Back.recons_sizOR,no_leaf);
        %--------------------------------------------------------------------------
        %% Current Flow Analysis
        length_profile = 5000;
        [Back.AllTrueProf] = voltage_profile(scriptvar.V(:,1:length_profile));
        if (~isempty(Back.A_iter))
            [err_mea] = Topology_Check(Back,scriptvar,no_leaf,length_profile);
        else
            continue
        end
        switch (phase)
            case(1)
                results.phA(iteration_number) = err_mea;
                % Compare Guesses with Visually Inferred True Graph
                [iter_err] = cmpTrueGraph(err_mea,Back,no_leaf,phA_true);
                results.phACMP(iteration_number) = iter_err;
                results.phABACK(iteration_number) = Back;
            case(2)
                results.phB(iteration_number) = err_mea;
                % Compare Guesses with Visually Inferred True Graph
                [iter_err] = cmpTrueGraph(err_mea,Back,no_leaf,phB_true);
                results.phBCMP(iteration_number) = iter_err;
                results.phBBACK(iteration_number) = Back;
            case(3)
                results.phC(iteration_number) = err_mea;
                % Compare Guesses with Visually Inferred True Graph
                [iter_err] = cmpTrueGraph(err_mea,Back,no_leaf,phC_true);
                results.phCCMP(iteration_number) = iter_err;
                results.phCBACK(iteration_number) = Back;
        end
        %% RESET VARIABLES
        clear Opt LS_exp C Back err_mea iter_err
    end
    clear scriptvar c check iimag Iimag ir Ireal length_profile no_leaf quadrant r
end