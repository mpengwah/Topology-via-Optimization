function [profilematrix] = voltage_profile(V)
[r,c] = size(V);
vec = 1;
for i=1:r
    for j=1:r
        if(i~=j)
            profilematrix(vec,:) = V(i,:) - V(j,:);
            vec = vec + 1;
        end
    end
end
profilematrix(profilematrix<0) = -1;
profilematrix(profilematrix>0) = 1;
end