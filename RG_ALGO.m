function [D,A,G,Dreactance] = RG_ALGO(D,Dreactance)
%Date Mod: 25/11/2019
set = 1:length(D);
sib=[];par=[];
A=[];
count = 1;
while (length(set)>2)
    %calculate the phi values and indices matrix
    [phi,phireact,ind] = calc_phi(D,Dreactance,set);
    %contains the index and phi values
    data = [ind phi];
    [r,c] = size(phi);
    %------------------------------------------
    %Part B Finding siblings and Parents
    linearidx = sub2ind(size(D),ind(:,1),ind(:,2));
    errsib = max(phi,[],2) - min(phi,[],2);
    errpar = abs(D(linearidx) - mean(phi,2));
    [minerrsib,minerrsib_idx]=min(errsib);
    [minerrpar,minerrpar_idx]=min(errpar);
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
    %----------------------------------------------
    %PART C
    % JOINING LINKS AND CREATING PARENTS
    %PARENTS
    par_nodes=[];
    if(~isempty(par))
        A(par(1),par(2)) = 1;
        A(par(2),par(1)) = 1;
        set(set==par(2))=[];
        set(set==par(1))=[];
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
        set(set==sib(2))=[];
        set(set==sib(1))=[];
        %-----------
        %PART D
        %Updating the Original Matrix
        [x,y]=find(A(head,:)==1);
        index = find((ismember(ind,[y(1),y(2)],'rows')==1));
        D(y(1),head) = 0.5 * (D(y(1),y(2)) + mean(phi(index,:)));%since |C(h)| would always be 2.
        D(y(2),head) = 0.5 * (D(y(2),y(1)) - mean(phi(index,:)));
        D(head,1:length(D(:,head))) = D(:,head)';
        Dreactance(y(1),head) = 0.5 * (Dreactance(y(1),y(2)) + mean(phireact(index,:)));%since |C(h)| would always be 2.
        Dreactance(y(2),head) = 0.5 * (Dreactance(y(2),y(1)) - mean(phireact(index,:)));
        Dreactance(head,1:length(Dreactance(:,head))) = Dreactance(:,head)';
        %Updating for all the other nodes
        for k=1:length(D)
            if (~ismember(k,y))
                D(k,head) = 0.5 * sum(D(y,k) - D(y,h));
                D(head,k) = D(k,head);
                Dreactance(k,head) = 0.5 * sum(Dreactance(y,k) - Dreactance(y,head));
                Dreactance(head,k) = Dreactance(k,head);
            end
        end
    end
    %------------------------
    %END CONDITION FOR DEBUGGING
    set=unique([set par_nodes head]);
    %RESETTING VARIABLES
    phi=[];ind=[];data =[];sib=[];par=[];
end

if (length(set)>1)
    [phi,ind] = calc_phi_endingcond(D,set);
    linearidx = sub2ind(size(D),ind(:,1),ind(:,2));
    errpar = abs(D(linearidx) - mean(phi,2));
    %that means they are connected to each other
    A(ind(1),ind(2)) = 1;
    A(ind(2),ind(1)) = 1;
end

%DISPLAYING RESULTS
G=graph(A);
end

