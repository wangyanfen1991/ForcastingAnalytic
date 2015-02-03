function output  = dGausienRespectToC(input , C , sigma , O)
   % cc = C( : , :);
    cc=C';
    for k=1:6
        xx = input - cc(k , :);
        for j=1:9
            GG(j , k) =  ((xx(j))/(sigma(k)^2))*O(k) ;
        end
    end
    output = GG;
end