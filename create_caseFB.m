function [mpc] = create_caseFB(An,Dn,Dnreact,F,renum,leaf_nodes,I,PF)
% Written By Pengwah Abu Bakr 
% ID: 27195139
% Date Mod: 22/11/2019
%INPUTS:
% An - Directed Graph Adjacency Matrix
% Dn - Resistance Matrix
% Dnreact - Reactance Matrix
% renum - Reordering sequence of the nodes
% Leaf_nodes - Ordering of leaf nodes in the system excluding slack bus
% F - Ordering Sequence ; It denotes the sending node number corresponding
% to the branch number (0 to N). Refer to Tree_Ordering.m
% I - Current data (Load Current)
% PF - Power Factor of the Load (Inductive: Positive PF, Negative: Capacitive)

%Outputs
% mpc - stores the structure for the load flow
% 1. Branch data
% 2. Bus data
% 3. Ordering Sequence
% 4. Tolerance Value, etc

%NOTE: BUS 1 IS always the SLACK BUS kept at 1.0 pu at an angle of 0 deg.
mpc.F = F; %store the ordering sequence
mpc.leaf_nodes = leaf_nodes; %Leaf Nodes Bus Numbers
%-----
%% LINE DATA
T = An .* Dn;
[r,c] = find(T~=0);
mpc.branch = zeros(length(r),13) ;
% fbus  tbus  r  x  b  rateA  rateB  rateC  ratio  angle  status  angmin  angmax
for i = 1:length(r)
    mpc.branch(i,1) = r(i); %'From'
    mpc.branch(i,2) = c(i); %'To'
    mpc.branch(i,3) = T(r(i),c(i)); %Resistance
    mpc.branch(i,4) = Dnreact(r(i),c(i)); %Inductance
    mpc.branch(i,5:end) = [0 999 999 999 0 0 1 -360 360]; %unused Columns
end
%-----
%% BUS DATA
%Note that here we use the current and power factor as input for the bus
%data
mpc.bus = zeros(length(Dn),13);
% bus_i  type  I  PF  Gs  Bs  area  Vm  Va  baseKV  zone  Vmax  Vmin
for i=1:length(Dn)
    mpc.bus(i,1) = i;
    if(i==1) %SLACK BUS
        mpc.bus(i,2) = 3;
        mpc.bus(i,3) = 0;
        mpc.bus(i,4) = 0;
    elseif (ismember(i,leaf_nodes)) %leaf nodes
        ind = find(renum(:,2)==i);
        row = renum(ind,1);
        mpc.bus(i,2) = 1;
        mpc.bus(i,3) = I(row-1);
        mpc.bus(i,4) = PF(row-1);
    else %any intermediate node
        mpc.bus(i,2) = 1;
        mpc.bus(i,3) = 0;
        mpc.bus(i,4) = 0;
    end
    mpc.bus(i,5) = 0;
    mpc.bus(i,6) = 0;
    mpc.bus(i,7) = 1;
    mpc.bus(i,8) = 1; % Voltage Mangitude Initialised to 1.0
    mpc.bus(i,9) = 0; % Voltage Angle Initialised to 0 degrees
    mpc.bus(i,10) = 415;%in V
    mpc.bus(i,11) = 1;
    %CAREFUL OF VMAX AND VMIN SINCE IN THE ACTUAL MEASUREMENTS SOMETIMES
    %THE VOLTAGE DROPS BELOW THE MINIMUM OR EXCEEDS THE MAXIMUM
    mpc.bus(i,12) = 1.1;
    mpc.bus(i,13) = 0.9;
end

end

