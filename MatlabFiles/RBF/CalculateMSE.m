function output  = CalculateMSE(errors)
    sum=1;
    for i =1 : size(errors ,1)
        sum = sum +( errors(i)^2);
    end
    output = sum/2;
end