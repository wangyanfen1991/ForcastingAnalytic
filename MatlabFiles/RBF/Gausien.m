function output  = Gausien(net , sigma )
    output =  exp(-0.5 * (net./sigma).^2 );
end