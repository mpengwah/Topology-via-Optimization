function [An,Gn,Dn,Dnreact,F,renum,leaf_nodesN] = tree_ordering(A,G,D,Dreact,leaf_nodes)
% Written By Pengwah Abu Bakr
% ID: 27195139
% Date Mod: 22/11/2019

% Desription: This function gets as input a unidirected graph that has
% the leaf nodes indices with the smallest number and outputs
% a directed and ordered graph starting from the slack bus and with the 
% leaf nodes having the maximum index

%INPUTS:
% - A: Adjacency Matrix of Unidirected Graph
% - G: matlab graph object of unidirected graph
% - D: Resistance Matrix Corresponding to unidirected graph
% - Dreact: Reactance Matrix Corresponding to unidirected graph
% - leaf_nodes: Number of leaf nodes in the system, excluding the slack bus

%OUTPUTS:
% - An: Adjacency Matrix of Directed and Ordered Graph
% - Gn: matlab graph object of Directed and Ordered graph
% - Dn: Resistance Matrix Corresponding to Directed and Ordered graph
% - Dnreact: Reactance Matrix Corresponding to Directed and Ordered graph
% - leaf_nodesN: Leaf Nodes bus number excluding slack bus
% - renum: renumbering sequence of the nodes: 1st column is the previous node number
% while 2nd column is the new node number
% - F: Branch Ordering Sequence
% For example, a graph with X amount of branches will have the F vector of size 1 by X;
% The entries of the F vector will be the sending node bus number of the branches.

%Create Directed Graph
% The Slack bus will be the root of the network
[Gd,Ad] = create_directed(A,G);

%ORDERING STARTS HERE
initial = 1:length(Ad); %Lists all the Bus Numbers in the network; this would be used
%as a check  that all the nodes in the network has been traversed through and renumbered
An = zeros(size(Ad));
vec = 1;renum=[0 0]; %initialised variables
renumvec = 1;
F=[]; %Branch Ordering Sequence

for i=2:length(Ad) %1 is always slack bus;and remains the same
    P = shortestpath(Gd,1,i); %find the sequence of bus numbers joining slack bus 
	%to any other node
    %reordering
    for j=2:length(P) %P(1) is the slack bus id and is ignored
        if(ismember(P(j),initial))
		%if the bus number is in the initial set, that means it hasn't been renumbered.
            if (ismember(P(j-1),renum(:,1)))
			%check if the previous bus number in P sequence was already renumbered.
			%If yes then the new connection from the new renumbered bus must be made to that
			% previous bus number
                r = find(P(j-1)==renum(:,1));
                vec = vec + 1; 
                An(renum(r,2),vec) = 1; %insert new entry
                F = [F renum(r,2)]; %store the sending node in the Branch Ordering Sequence
                renum(renumvec,:) = [P(j) vec]; %store the current renumbering nodes number
                renumvec = renumvec + 1;
                initial(initial==P(j))=[]; %remove the node from the list
				%this would signify that we have already traversed through that node
            else
			% only for direct connections to the slack bus
                vec = vec + 1;
                An(1,vec) = 1; %Connection to Slack Bus
                F = [F 1]; %Store the sending node in the Branch Ordering Sequence
                renum(renumvec,:) = [P(j) vec];
                renumvec = renumvec + 1;
                initial(initial==P(j))=[]; %remove the node from the list
            end
        end
    end
end
renum = [1 1;renum]; %add the slack bus numbering at the top; the slack bus is unchanged
for i=1:length(An)
    for j=1:length(renum)
	%reordering the distance matrices in similar fashion as the nodes
        Dn(i,renum(j,2)) = D(renum(i,1),renum(j,1)); 
        Dnreact(i,renum(j,2)) = Dreact(renum(i,1),renum(j,1));
    end
end
Gn = digraph(An); %create the directed graph

%new_leafindices
old_leaf = [2:leaf_nodes+1];
for i = 1:length(old_leaf)
    r=find(renum(:,1)==old_leaf(i));
    leaf_nodesN(i) = (renum(r,2));%store the vector containing the bus number of the leaf nodes
end

end

