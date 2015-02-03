%*******************************************
% Game Analytic Data Forcasting
% Elham Rahimi : 9305564
%  ....
%*******************************************

%% normalized The data Sets
data =Normalized();

%% Get Ready to Use
dataSet = makeDataSets( data );
dataSet = dataSet ( randperm(end),: );

usedDataSets = dataSet(1:108 , :);
testDataSets = dataSet(109:129 , :);


%% Initialized weights and other parameters
numberOfEpoch = 1200;

hiddenNeruns = 6;
inputSize =9;
rand('state',7);