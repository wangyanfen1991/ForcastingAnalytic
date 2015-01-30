%********************************************************
%this function makes normalized dataSet 
%********************************************************

function [dataSet  ] = Normalized( )

    load data;
    
    
    
    
    for  k=1:9 
        maxValu = max([data{: , k }]);
        minValu = min([data{: , k }]);
        for  m=1:149
            normalizedDataSet(m , k) = (data{m , k }- minValu)/(maxValu-minValu);
        end
    end
    
    dataSet = normalizedDataSet;
    
end