function [A_iter,D_iter,recons_siz,Dreact_iter] = BackTrackv2(Dor,Dreactance,leaf_node)
% This function is similar to the RG algorithm
%except that its gonna produce every possible combination of graphs
%possible
% Input: Distance Matrix
% Outputs:
% - A_iter: Adjacency matrix of all the possible configurations (iter by N)
% - D_iter: Corresponding Distance Matrix of all the possible (iter by N)
% matrix
% configurations
% - recons_size: denotes the length of each entry of the A and D matrices
% when reconstructing the full matrix (N by N)

%General Procedure:
% Input distance matrix of the leaf nodes
% do general RG algorithm when considering the leaf nodes
% when encountering an intermediate node: 
% force choose the parent condition
% push the current distance matrix onto the stack along the current
% reactance matrix, size of the matrix and the idx corresponding to the
% nodes chosen
% then carry on the normal procedure until again an intermediate node is
% met -> push every information onto the stack
% once a graph is completed. store that in A_iter,D_iter, etc
% select the last entry of the stack and delete it after transferring the
% content to the D and Dreact,  and A matrices.
% using the stored idx of the nodes, choose siblng condition for the
% bracnhing and repeat normal procedure until the final condition is
% reached again
%in the process other entries can be appended to the stack
% the algorithm is repeated until the stack is emptied

set_curr = 1:length(Dor);
sib=[];par=[];
A=[];

%Backtracking Initialization
vec = 1;
norm_procedure=1;
D = Dor;
Dreact = Dreactance;
stack_distanceR = [];
stack_adjacency = [];
stack_idx=[];
stack_set = [];
stack_distanceX = [];

while (length(set_curr)>2)
    %calculate the phi values and indices matrix
    [phi,phireact,ind] = calc_phi(D,Dreact,set_curr);
    %Part B Finding siblings and Parents
    linearidx = sub2ind(size(D),ind(:,1),ind(:,2));
    errsib = max(phi,[],2) - min(phi,[],2);
    errpar = abs(D(linearidx) - mean(phi,2));
    
    [minerrsib,minerrsib_idx]=min(errsib);%sibling condition
    [minerrpar,minerrpar_idx]=min(errpar);%parent condition
    if(norm_procedure)
        [branch_val] = min(minerrsib,minerrpar);
        if (branch_val == minerrsib)
            branch_idx = minerrsib_idx;
            sib = [ind(branch_idx,1) ind(branch_idx,2)];
        else
            branch_idx = minerrpar_idx;
            if (phi(branch_idx,:)>0)
                par=[ind(branch_idx,2),ind(branch_idx,1)];
            else
                par=[ind(branch_idx,1), ind(branch_idx,2)];
            end
        end
        if (sum(ismember(ind(branch_idx,:),[1:leaf_node+1]))~=2)
            [r,~] = size(stack_distanceR);
			%Append the current distance, adjacency and set_matrices to END of stack_adjacency
			% Also store the ID's of the nodes and the size of the matrix being stored
			% in the stack
            temp = reshape(D,[1 length(D)^2]);
            stack_distanceR(r+1,1:length(temp)) = temp;
            temp = reshape(Dreact,[1 length(Dreact)^2]);
            stack_distanceX(r+1,1:length(temp)) = temp;
            temp = reshape(A,[1 length(A)^2]);
            stack_adjacency(r+1,1:length(temp)) = temp;
            stack_idx(r+1,:) = branch_idx;
            stack_siz(r+1,:) = length(D);
            stack_set(r+1,1:length(set_curr)) = set_curr;
            %Choose Parent First
            sib=[];
            if (phi(branch_idx,:)>0)
                par=[ind(branch_idx,2),ind(branch_idx,1)];
            else
                par=[ind(branch_idx,1), ind(branch_idx,2)];
            end
        end
    else
        sib = [ind(decision_branching,1) ind(decision_branching,2)];
    end
    %----------------------------------------------
    %PART C
    % JOINING LINKS AND CREATING PARENTS
    %PARENTS
    par_nodes=[];
    if(~isempty(par))
        A(par(1),par(2)) = 1;
        A(par(2),par(1)) = 1;
        set_curr(set_curr==par(2))=[];
        set_curr(set_curr==par(1))=[];
        par_nodes(length(par_nodes) + 1) = par(1);
    end
    %SIBLINGS -> Implying Parent needs to be created and Adjacency matrix
    %must be updated
    head=[];
    if(~isempty(sib))
        h = length(D);
        check = [];
        head(length(head) + 1) = h + 1;
        h=h+1;
        A(h,sib(1))=1;
        A(sib(1),h)=1;
        A(h,sib(2))=1;
        A(sib(2),h)=1;
        set_curr(set_curr==sib(2))=[];
        set_curr(set_curr==sib(1))=[];
        %-----------
        %PART D
        %Updating the Original Matrix
        [x,y]=find(A(head,:)==1);
        index = find((ismember(ind,[y(1),y(2)],'rows')==1));
        D(y(1),head) = 0.5 * (D(y(1),y(2)) + mean(phi(index,:)));%since |C(h)| would always be 2.
        D(y(2),head) = 0.5 * (D(y(2),y(1)) - mean(phi(index,:)));
        D(head,1:length(D(:,head))) = D(:,head)';
        Dreact(y(1),head) = 0.5 * (Dreact(y(1),y(2)) + mean(phireact(index,:)));%since |C(h)| would always be 2.
        Dreact(y(2),head) = 0.5 * (Dreact(y(2),y(1)) - mean(phireact(index,:)));
        Dreact(head,1:length(Dreact(:,head))) = Dreact(:,head)';
        %Updating for all the other nodes
        for k=1:length(D)
            if (~ismember(k,y))
                D(k,head) = 0.5 * sum(D(y,k) - D(y,h));
                D(head,k) = D(k,head);
                Dreact(k,head) = 0.5 * sum(Dreact(y,k) - Dreact(y,head));
                Dreact(head,k) = Dreact(k,head);
            end
        end
    end
    %------------------------
    %END CONDITION FOR DEBUGGING
    set_curr=unique([set_curr par_nodes head]);
    if (length(set_curr)==2)
        %MAKE THE FINAL CONNECTION
        A(set_curr(1),set_curr(2)) = 1;
        A(set_curr(2),set_curr(1)) = 1;
        %Store the final sequence
        temp = reshape(D,[1 length(D)^2]);
        D_iter(vec,1:length(temp)) = temp;
        temp = reshape(Dreact,[1 length(Dreact)^2]);
        Dreact_iter(vec,1:length(temp)) = temp;
        temp = reshape(A,[1 length(A)^2]);
        A_iter(vec,1:length(temp)) = temp;
        recons_siz(vec,:) = length(D);
        vec = vec + 1;
        %RETRIEVE THE LAST element of stack
        norm_procedure = 0;%%OSCILLATE BETWEEN DECISIONS
        if (isempty(stack_distanceR))
            %if stack is empty that implies all backtracking has been
            %considered
            break;
        end
        temp = stack_distanceR(end,1:stack_siz(end)^2);
        D = reshape(temp,[stack_siz(end) stack_siz(end)]);
        temp = stack_distanceX(end,1:stack_siz(end)^2);
        Dreact = reshape(temp,[stack_siz(end) stack_siz(end)]);
        temp = stack_adjacency(end,1:stack_siz(end)^2);
        A = reshape(temp,[stack_siz(end) stack_siz(end)]);
        set_curr = stack_set(end,:);
        set_curr(set_curr==0)=[];
        decision_branching = stack_idx(end);
        %Delete Last Entry of Stack
        stack_distanceR(end,:)=[];
        stack_distanceX(end,:)=[];
        stack_adjacency(end,:)=[];
        stack_idx(end,:)=[];
        stack_set(end,:)=[];
        stack_siz(end,:)=[];
    else
        %RESET THE NORMAL RG PROCEDURE
        norm_procedure = 1;
    end
    %RESETTING VARIABLES
    phi=[];ind=[];data =[];sib=[];par=[];phireact=[];
end
end

