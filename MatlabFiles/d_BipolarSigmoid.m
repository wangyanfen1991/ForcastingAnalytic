%******************************************************************
%function to calculate Derivative of BipolarSigmoid of each element
%******************************************************************
function y = d_BipolarSigmoid(x , g)
    x = (1 + BipolarSigmoid(x,g) );
    z = (1 - BipolarSigmoid(x,g) );
    y=0.5*(x.*z) ;
end