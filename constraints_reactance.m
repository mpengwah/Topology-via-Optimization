function [A,b,Aeq,beq,Aineq,bineq] = constraints_reactance(r,c,X,v)
A = zeros(r/2*c,2*(r/2)^2);

for k=1:r/2
    row = 1 + (k-1)*c;
    col = 1 + (k-1)*r;
    A(row:row+c-1,col:col+r-1) = X';
end
b = zeros(r/2*c,1);
for k = 1:r/2
    row = 1 + (k-1)*c;
    b(row:row+c-1) = v(k,1:c);
end
%-----------
%CONSTRAINTS
n = r/2;

% real_indices
ind = 1:n;
Tr = zeros(n,n);
T = ind;

for i = 1:n-1
    ind = ind + 2*n;
    T(length(T)+1:length(T)+n) = ind;
end
Ttest = reshape(T,[n n]);
Tr = Ttest;

Aeq = zeros(2*n^2);
beq = zeros(2*n^2,1);
for j=1:n
    for k=1:n
        if (j~=k)
            Aeq(Tr(j,k),Tr(j,k)) = 1;
            Aeq(Tr(j,k),Tr(k,j)) = -1;
        end
    end
end

%imag indices
ind = n+1:n+n;
Tr = zeros(n,n);
T = ind;
for i = 1:n-1
    ind = ind + 2*n;
    T(length(T)+1:length(T)+n) = ind;
end
Ttest = reshape(T,[n n]);
Tr = Ttest;

for j=1:n
    for k=1:n
        if (j~=k)
            Aeq(Tr(j,k),Tr(j,k)) = 1;
            Aeq(Tr(j,k),Tr(k,j)) = -1;
        end
    end
end
%--------=--------------------
%inequality: diagonal > off-diagonal
poz_rea= zeros(n,1);
%positions of diagonals
for i = 1:n
    poz_rea(i) = 1 + (i-1)*(2*n+1);
end


%ima
poz_ima = zeros(n,1);
%positions of diagonals
for i = 1:n
    poz_ima(i) = (1+n) + (i-1)*(2*n+1);
end

%real indices
ind = 1:n;
Tr = zeros(n,n);
T = ind;

for i = 1:n-1
    ind = ind + 2*n;
    T(length(T)+1:length(T)+n) = ind;
end
Ttest = reshape(T,[n n]);
Tr = Ttest;
Aineq = zeros(1,2*n^2);
for i = 1:n
    for j = 1:n
        if(i~=j)
            Aineq(j+n*(i-1),poz_rea(i))=1;
            Aineq(j+n*(i-1),Tr(i,j)) = -1;
        end
    end
end

%ima
ind = n+1:n+n;
Tr = zeros(n,n);
T = ind;

for i = 1:n-1
    ind = ind + 2*n;
    T(length(T)+1:length(T)+n) = ind;
end
Ttest = reshape(T,[n n]);
Tr = Ttest;
Aineq_ima = zeros(1,2*n^2);
for i = 1:n
    for j = 1:n
        if(i~=j)
            Aineq_ima(j+n*(i-1),poz_ima(i))=1;
            Aineq_ima(j+n*(i-1),Tr(i,j)) = -1;
        end
    end
end
Aineq = [Aineq; Aineq_ima];
[rineq,~]=size(Aineq);
bineq = zeros(rineq,1);
end

