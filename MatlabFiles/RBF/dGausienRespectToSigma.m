function output  = dGausienRespectToSigma(net , sigma , O)
    output =  ((net.^2)./(sigma.^3)).*O ;
end