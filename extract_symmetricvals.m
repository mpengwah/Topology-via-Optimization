function [S] = extract_symmetricvals(x,n,choice)
switch(choice)
    case(1)
        ind = 1:n;
        T = x(ind);
        for i = 1:n-1
            ind = ind + 2*n;
            T(length(T)+1:length(T)+n) = x(ind);
        end
        S = -1* reshape(T,[n n]);
    case(2)
        ind = n+1:n+n;
        T = x(ind);
        for i = 1:n-1
            ind = ind + 2*n;
            T(length(T)+1:length(T)+n) = x(ind);
        end
        S = -1* reshape(T,[n n]);
end

end

