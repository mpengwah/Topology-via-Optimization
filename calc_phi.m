function [phi,phireact,ind] = calc_phi(D,Dreactance,set)
%Date Mod: 25/11/2019
x=1;y=1;
for i=1:length(set)
    for j = i+1:length(set)
        for k = 1:length(set)
            if (set(k) ~=set(i) && set(k) ~= set(j))
                phi(y,x) = (D(set(i),set(k)) - D(set(j),set(k)));
                phireact(y,x) = Dreactance(set(i),set(k)) - Dreactance(set(j),set(k));
                ind(y,:) = [set(i) set(j)];
                x = x+1;
            end
        end
        y=y+1;    x=1;
    end
end
end

