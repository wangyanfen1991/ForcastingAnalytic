%********************************************************
%this function makes dataSet of parameters
%********************************************************

function [result  ] = makeDataSets( dataSet )
    index=1;
    for k =1:129
        for l =0 : 2
           %for m =1 :11
                m =1;
               data(index , (m+(l*3))  ) = dataSet(k+l ,m );
               data(index , (m+1+(l*3))  ) = dataSet(k+l ,m+3 );
               data(index , (m+2+(l*3))  ) = dataSet(k+l ,m+7 );
           %end
        end
        data(index , 10) = dataSet(k+3 , 4);
        index = index+1;
    end
    
    result = data;
end