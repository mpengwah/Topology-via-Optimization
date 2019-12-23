function [D] = distance_matrix(Sp)
%calculate the distance matrix from the sensitvity matrix
%the first entry is always the slack bus values
dr = zeros(length(Sp)+1);
slack  = diag(Sp);
for i=1:length(Sp)
    for j=1:length(Sp)
        dr(i+1,j+1) = Sp(i,i) + Sp(j,j) - 2 * Sp(i,j);
    end
end
D = dr;
D(1,2:end) = slack;
D(2:end,1) = slack;
end

