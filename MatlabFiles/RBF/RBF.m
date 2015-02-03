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
numberOfEpoch = 1000;

hiddenNeruns = 6;
inputSize =9;
rand('state',7);

etha1 = 0.2;
etha2 = 0.2;

C = rand(inputSize , hiddenNeruns);
sigma = rand(1 , hiddenNeruns);%ones(1,hiddenNeruns);%rand(1 , hiddenNeruns);
W2 = rand(hiddenNeruns , 1);


%% Main loop for each Epoch

for i = 1: numberOfEpoch
   %% make train and eval data
   usedDataSets = usedDataSets(randperm(end),:);
   trainDataSets = usedDataSets(1:108 , :);
   evalDataSets = usedDataSets(90:108 , :);
   
   %% Satrt each Epoch
   e=0;
   eval_error=0;
   for j=1 : 100
       % ********************************
       % define input and output
       %*********************************
       input = trainDataSets(j , 1:inputSize );
       output = trainDataSets (j , inputSize+1);
       
       %% Learning with Train data
       
       %**********************
        % FeedForward
        %**********************
        
        net1 = calculateNorm( input , C );  
        O1=  Gausien(net1 , sigma );
        
        net2 = O1 * W2;
        
        O2 = purelin(net2 );
                
        %**********************
        % BackPropagation
        %**********************
        
        error(j) = output - O2;  
        
        %****** < Train Sigma > ******
        delta_sigma = error(j)*0.5*W2'.* dGausienRespectToSigma(net1 ,sigma , O1) .*O1 ;
       
        
        %********<  C > *********
        dG = dGausienRespectToC(input,C ,sigma , O1);
        for y =1:inputSize
            
        delta_C(y , :) = error(j)*0.5*W2'.* dG(y,:).*O1 ;
                 
        end

        
        %****** <  W >***********
        
        deltaW = 0.5*error(j)*O1'; %derivative of pureline is 1 so I don't mention in it

        
        %*********< Train all together > **********
        
        W2 = W2 + etha2 * deltaW;
        sigma = sigma + etha1* delta_sigma;
        C = C + etha1*delta_C;
        
   end   
   
    %***********< MSE Test >*************
    TrainMSE(i) = mse(error(:));

%% Eval Training   
                
    for j=1 :  18
       % ********************************
       % define input and output
       %*********************************
       input = trainDataSets(j , 1:inputSize );
       output = trainDataSets (j , inputSize+1);
        
        %**********************
        % EvalFeedForward
        %********************** 
        net1 = calculateNorm( input , C );  
        O1=  Gausien(net1 , sigma );
        
        net2 = O1 * W2;
        
        O2 = purelin(net2 );

        errorEval(j) = output - O2; 

    end
    EvalMSE(i) = mse(errorEval(:));
    
    %*********************************
    % Finish Evaluating
    %*********************************
end

%% Test

for j=1:20
   % ********************************
   % define input and output
   %*********************************
   input = trainDataSets(j , 1:inputSize );
   output = trainDataSets (j , inputSize+1);    

    net1 = calculateNorm( input , C );  
    O1=  Gausien(net1 , sigma );

    net2 = O1 * W2;

    O2 = purelin(net2 );

    errorTest(j) = output - O2;
    desire(j) = output;
    errorOutput(j) = O2;
end

TestMSE = mse(errorTest(:));
    
figure
plot (1:i ,TrainMSE);
figure
plot (1:i ,EvalMSE);
figure
plot(1:20 ,desire , 1:20 , errorOutput);
