%********************************************************
%this function makes normalized dataSet 
%********************************************************

function [result  ] = Normalized( )

    load data;
    dataSet = ones(132,11);
    
    for ss=1:132
       for kk=1:11
           dd = data{ss , kk };
           if(dd == 0)
               dataSet(ss , kk)= 0;
           else
               dataSet(ss , kk) =  str2double(dd);
           end
       end
    end
    
    %result = dataSet;
    
    for  k=1:9 
        maxValu = max(dataSet(: , k ));
        minValu = min(dataSet(: , k ));
        for  m=1:132
            normalizedDataSet(m , k) = (dataSet(m , k )- minValu)/(maxValu-minValu);
        end
    end
    
    for k=10:11
       for m=1:132
             normalizedDataSet(m , k) = dataSet(m , k );
       end
    end
    
    result = normalizedDataSet;
    
end