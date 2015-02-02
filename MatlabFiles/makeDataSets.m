%********************************************************
%this function makes dataSet of parameters
%********************************************************

function [result  ] = makeDataSets( dataSet )
    index=1;
    for k =1:142
        for l =0 : 6
           for m =1 :11
               data(index , (m+(l*11))  ) = dataSet(k+l ,m );
           end
        end
        data(index , 78) = dataSet(k+7 , 4);
        index = index+1;
    end
    
    result = data;
end