%*************************************************************
%function to calculate BipolarSigmoid of each element
%*************************************************************
function y = BipolarSigmoid( x , g)
    temp =  exp(-1*g.*x );
    temp = temp';
    x= size(temp,1);
    for(i=1: x)
        y(1 , i)=-1+(2/(1+ temp(i,1) ));
    end
end