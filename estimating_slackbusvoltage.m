clc;clear all;close all;
%Written By Pengwah Abu Bakr
%ID: 27195139

load test_parfor

[scriptvar.r,scriptvar.c] = size(Back.A_iter); %All Possible Scenarios
Back.Vnom = 240; %Slack Bus Voltage
BFopt.verbose=0; %Suppress Printng to console
ratio = 2; %Use a fix R/X ratio
iter = 1;
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
    %Keep a fix R/X ratio
    scriptvar.Dlf_react = scriptvar.Dlf_resis / ratio;
    %----------------
    %REORDERING TREE
    [scriptvar.An,scriptvar.Gn,scriptvar.Dn,scriptvar.Dnreact,scriptvar.F...
        ,scriptvar.renum,scriptvar.leaf_nodesN] = tree_ordering(scriptvar.A...
        ,scriptvar.G,scriptvar.Dlf_resis,scriptvar.Dlf_react,no_leaf);
    for k =1:length(scriptvar.V(:,1:length_profile))
        [mpc] = create_caseFB_specialSlackBus(scriptvar.An,scriptvar.Dn,...
            scriptvar.Dnreact,scriptvar.F,scriptvar.renum,...
            scriptvar.leaf_nodesN,scriptvar.I(:,k),scriptvar.pf(:,k),scriptvar.V(:,k));
        Vslack = calc_SlackBusVolt(mpc,scriptvar);
%         [bus_no,~] = size(mpc.bus); % get the number buses in the network
%         mpc.cal_V = mpc.bus(:,8); % 
%         for i = bus_no:-1:2 %do it in a decreasing order starting from the leaf nodes
%             if (~ismember(i,mpc.F))
%                 % if its a leaf node, branch current = load current
%                 %3rd bus column - Current mag
%                 %4th bus column - power factor
%                 %9th bus column - voltage angle
%                 pf_angle = acosd(abs(mpc.bus(i,4))) * sign(mpc.bus(i,4)); %in degrees
%                 branch_angle = mpc.bus(i,9) - pf_angle; %in degrees, thetaV - thetaI = acos(pf)
%                 mpc.calc_I(i,:) = mpc.bus(i,3) * (cosd(branch_angle) + 1j * sind(branch_angle));
%             elseif (ismember(i,mpc.F) & ismember(i,mpc.leaf_nodes))
%                 tf = (mpc.F  ==i);
%                 poz = find(tf==1);
%                 poz = poz + 1;
%                 %load current of the leaf node
%                 pf_angle = acosd(abs(mpc.bus(i,4))) * sign(mpc.bus(i,4)); %in degrees
%                 branch_angle = mpc.bus(i,9) - pf_angle; %in degrees, thetaV - thetaI = acos(pf)
%                 Load_current = mpc.bus(i,3) * (cosd(branch_angle) + 1j * sind(branch_angle));
%                 mpc.calc_I(i,:) = sum(mpc.calc_I(poz)) + Load_current;
%             else
%                 % else the branch current is one with an intermediate node as the sending node
%                 tf = (mpc.F  ==i); %find the node corresponding to the sending intermediate bus
%                 poz = find(tf==1); %position in ordering vector
%                 poz = poz + 1; %translated to the node number(s) that are connected to the intermediate bus
%                 mpc.calc_I(i,:) = sum(mpc.calc_I(poz)); %I(inter_bus) = sum of all the branch currents with
%                 %the inter_bus as sending node
%             end
%         end
    end
end
%%
% 
% %backward method to calculate the voltage of slack bus
% for k = 1:length(mpc.leaf_nodes)
%     P = shortestpath(scriptvar.Gn,1,mpc.leaf_nodes(k));
%     P(1)=[];
%     [r] = find(ismember(mpc.branch(:,2),P));
%     impedance = (mpc.branch(r,3) + 1j * mpc.branch(r,4));
%     Vslack(k) = mpc.cal_V(mpc.leaf_nodes(k)) + sum(impedance .* mpc.calc_I(P));
% end