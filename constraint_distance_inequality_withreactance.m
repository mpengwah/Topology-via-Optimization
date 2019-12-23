function [C] = constraint_distance_inequality_withreactance(r,x,C)
%INPUTS:
% r: size of sensitvity matrix
% x: decision variables (sensitvity coefficients)
% C: initial Set of Constraints (from constraints_reactance.m)
% OUTPUTS:
% C: Final Set of Constraints: traingle inequality;
n = r/2;
ind = 1:n;
Tr = zeros(n,n);
T = ind;

for i = 1:n-1
    ind = ind + 2*n;
    T(length(T)+1:length(T)+n) = ind;
end
Ttest = reshape(T,[n n]);
Tr = Ttest;
%D matrix as spdvar
for i=1:n
    for j=1:n %put i here or 1
        %putting i will do it for the upper triangular only; then add
        %D(j,i) = D(i,j)
        if(i~=j)
            D(i,j) = -1*(x(Tr(i,i)) + x(Tr(j,j)) - 2*x(Tr(i,j)));
        end
            
    end
end

C = [C, D>=0];

%TRIANGLE INEQUALITY
for i=1:n
    for j=1:n
        for k=1:n
            C = [C, D(i,j) - D(i,k) - D(j,k) <=0];
        end
    end
end
%--------------------------------------------------------------------------
%for the reactances
ind = n+1:n+n;
Tr = zeros(n,n);
T = ind;
for i = 1:n-1
    ind = ind + 2*n;
    T(length(T)+1:length(T)+n) = ind;
end
Ttest = reshape(T,[n n]);
Tr = Ttest;

%D matrix as spdvar
for i=1:n
    for j=1:n %put i here or 1
        %putting i will do it for the upper triangular only; then add
        %D(j,i) = D(i,j)
        if(i~=j)
            D(i,j) = -1*(x(Tr(i,i)) + x(Tr(j,j)) - 2*x(Tr(i,j)));
        end
            
    end
end
C = [C, D>=0];
%TRIANGLE INEQUALITY
for i=1:n
    for j=1:n
        for k=1:n
            C = [C, D(i,j) - D(i,k) - D(j,k) <=0];
        end
    end
end
end

