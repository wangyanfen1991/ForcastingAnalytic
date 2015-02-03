function normValue  = calculateNorm(X , cc )
    for k=1:6
        value =0;
        for i=1 : 9
            value = value + (( X(i) - cc(i,k) )^2);
        end
        normValue(k) = sqrt(value);
    end
end