function [LF_results,success] = runBF_LF(mpc,Vnom,BFopt)
% Written By Pengwah Abu Bakr
% ID: 27195139
% Date Mod: 22/11/2019
%Inputs:
% mpc - data structure containing the bus number, load current and power factor of the loads.
% Refer to the create_caseFB.m
% Vnom - Nominal Voltage of the network in Volts
% Outputs:
% Success - Flag to determine if the Backward and forward (BF method) sweep method converged
% 1 denotes BF method converged and zero denotes failure
% LF_results - Stores the bus data (Voltages' magnitudes and angles after convergence),
% the branch currents

% CODING STARTS HERE
tol = 1.0e-08; % Tolerance to check whether the calculated voltages have reached a steady final
%result


[bus_no,~] = size(mpc.bus); % get the number buses in the network
mpc.cal_V = mpc.bus(:,8) * Vnom; % initialise the voltages to 1.0 pu * Vnom
Vold = mpc.cal_V;
iter_count = 1; %keep track of the iteration number
success = 0;	%success flag
iter_max = 50; %maximum possible number of iterations

while(success==0 & iter_count < iter_max)
    %% BACKWARD SWEEP
    %Compute all branch current
    for i = bus_no:-1:2 %do it in a decreasing order starting from the leaf nodes
        if (~ismember(i,mpc.F))
            % if its a leaf node, branch current = load current
            %3rd bus column - Current mag
            %4th bus column - power factor
            %9th bus column - voltage angle
            pf_angle = acosd(abs(mpc.bus(i,4))) * sign(mpc.bus(i,4)); %in degrees
            branch_angle = mpc.bus(i,9) - pf_angle; %in degrees, thetaV - thetaI = acos(pf)
            mpc.calc_I(i,:) = mpc.bus(i,3) * (cosd(branch_angle) + 1j * sind(branch_angle)); 
        elseif (ismember(i,mpc.F) & ismember(i,mpc.leaf_nodes))
            tf = (mpc.F  ==i);
            poz = find(tf==1);
            poz = poz + 1;
            %load current of the leaf node
            pf_angle = acosd(abs(mpc.bus(i,4))) * sign(mpc.bus(i,4)); %in degrees
            branch_angle = mpc.bus(i,9) - pf_angle; %in degrees, thetaV - thetaI = acos(pf)
            Load_current = mpc.bus(i,3) * (cosd(branch_angle) + 1j * sind(branch_angle));
            mpc.calc_I(i,:) = sum(mpc.calc_I(poz)) + Load_current;
        else
            % else the branch current is one with an intermediate node as the sending node
            tf = (mpc.F  ==i); %find the node corresponding to the sending intermediate bus
            poz = find(tf==1); %position in ordering vector
            poz = poz + 1; %translated to the node number(s) that are connected to the intermediate bus
            mpc.calc_I(i,:) = sum(mpc.calc_I(poz)); %I(inter_bus) = sum of all the branch currents with
            %the inter_bus as sending node
        end
    end
    
    %% FORWARD SWEEP
    % Once the branch currents are found, we use those to calculate the new bus voltages starting from
    % the slack bus set at 1.0 pu at an angle of zero degrees (reference)
    %Compute Node voltages
    for i = 2:bus_no
        poz = mpc.F(i-1); %sending node or parent node
        mpc.cal_V(i,:) = mpc.cal_V(mpc.F  (i-1)) - mpc.calc_I(i) * (mpc.branch(i-1,3) + ...
            1j * mpc.branch(i-1,4));
        %branch number = current bus_no(=i) - 1
    end
    
    % Update the bus data voltages (both the magnitude and the angle) with the new
    % calculated voltages
    mpc.bus(:,8) = abs(mpc.cal_V); %magnitude
    mpc.bus(:,9) = angle(mpc.cal_V)*180/pi; % angle, in degrees
    err_val = max(abs(mpc.cal_V - Vold)); %error check
    
    % Check for steady state solution
    if (err_val>tol)
        % Failed to reach convergence
        iter_count = iter_count + 1;
        Vold = mpc.cal_V; % Update Old voltages with the new complex calculated voltages
        success = 0;
    else
        success = 1; %end while loop
    end
end

% Printing to the Matlab Command Window
if (BFopt.verbose)
    if (success==1)
        fprintf('LF Converged in %d Iterations!!\n',iter_count)
    else
        fprintf('Failed to Converge within 50 iterations')
    end
end
% Ouput the Voltages and Currents
LF_results = mpc;
field ={'branch','F','leaf_nodes','cal_V'}; % remove redundant fields
LF_results = rmfield(LF_results,field);
end

