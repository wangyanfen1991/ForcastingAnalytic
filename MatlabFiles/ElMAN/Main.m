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

Xc(1:1 , 1: hiddenNeruns) = 0.5;
W1 = rand(inputSize , hiddenNeruns);
W2 = rand(hiddenNeruns ,1  );
Wc = rand(hiddenNeruns,hiddenNeruns);
W1b = rand(1, hiddenNeruns );
W2b = rand(1,1 );
G1 = rand( 1,hiddenNeruns)*2 -1;

eta = 0.4;
gamma = 0.01;
eta1(1:inputSize,1:hiddenNeruns) = 0.4;
eta2(1:hiddenNeruns,1:1) = 0.4;
etaC(1:hiddenNeruns,1:hiddenNeruns) = 0.04;
eta1b(1:1,1:hiddenNeruns) = 0.04;
eta2b(1:1,1:1) = 0.04;
etaG(1:hiddenNeruns) = 0.04;

delta2 =0.0001;
delta1(1:1 , 1:hiddenNeruns) =0.0001;


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
       %*********************************
       % FeedForward
       %*********************************
       net1 = input * W1 + Xc * Wc + W1b;
       O1 = logsig(net1);%BipolarSigmoid(net1 , G1);
       net2 = O1 * W2 + W2b ;
       O2 = purelin( net2);
       Xc = O1;
       
       error = output - O2;
       
       %*********************************
       % keep track of some data
       %*********************************
       e(j) = error;
       delta2Before = delta2;
       delta1Before = delta1;
       
       %*********************************
       % Back propagasion
       %*********************************
       delta2 = error ;
       delta1 = delta2 * W2' .* dlogsig(net1 , O1);%d_BipolarSigmoid(net1 , G1);
       
       %*********< Train W >************
       W1 = W1 + eta1 .*( input' * delta1);
       W2 = W2 + eta2 * delta1 * O1';
       Wc = Wc + etaC .* (Xc' * delta1);
       
       %********<Train bias >***********
       W1b = W1b + eta1b .* delta1;
       W2b = W2b + eta2b * delta2;
       
       %sigma1 = error;
       %sigma2 = delta2 * W2' .* d_BipolarSigmoid(net1 , G1);
       
       %********< Train G >*************
      % G1 = G1 + etaG * sigma1;
       
       %*******< Train eta >************
       for k = 1: inputSize
            for m=1: hiddenNeruns 
                eta1(k,m )= eta1(k,m) - gamma *((input(1,k)*delta1(1,m))*(input(1,k)*delta1Before(1,m)));
            end
       end
       for k = 1: hiddenNeruns
            for m=1: 1 
                eta2(k,m )= eta2(k,m) - gamma *((O1(1,k)*delta2(1,m))*(O1(1,k)*delta2Before(1,m)));
            end
       end
        for k = 1: hiddenNeruns
            for m=1: hiddenNeruns 
                etaC(k,m )= etaC(k,m) - gamma *((Xc(1,k)*delta1(1,m))*(Xc(1,k)*delta1Before(1,m)));
            end
       end
       
       %*********************************
       % Finish Training
       %*********************************
   end
   
   TrainMSE(i) = mse(e(:));
   
   
   %% Eval Trainig
   for j =1 : 18
    % ********************************
    % define input and output
    %*********************************
    input = evalDataSets(j , 1:inputSize );
    output = evalDataSets (j , inputSize+1);
    
    %**********************
    % EvalFeedForward
    %**********************
    net1 = input * W1 + Xc * Wc + W1b;
    O1 = logsig(net1);%BipolarSigmoid(net1 , G1);
    net2 = O1 * W2 + W2b ;
    O2 = purelin( net2);
    Xc = O1;
    eval_error(j) = (output - O2);
       
   end
   
   EvalMSEerror = mse(eval_error);
   eva(i) = EvalMSEerror;
   
    %*********************************
    % Finish Evaluating
    %*********************************
    
end


%% Test
for j =1 : 20  
    % ********************************
    % define input and output
    %*********************************
       input = testDataSets(j , 1:inputSize );
       output = testDataSets(j , inputSize+1);
       
    %*********************************
    % TestFeedForward
    %*********************************  
       net1 = input * W1 + Xc * Wc + W1b;
       O1 = logsig(net1);%BipolarSigmoid(net1 , G1);
       net2 = O1 * W2 + W2b ;
       O2 = purelin( net2);
       Xc = O1;
    
    %*********************************
    % Save some data
    %*********************************
       test_error(j) = (output - O2);
       test_output(j) = O2;
       test_target(j) = output;
end
   
   TestMSEerror = mse(test_error);
   %test(i) = TestMSEerror;
   
   %*********************************
   % Finish Testing
   %*********************************

figure
plot(1:i , TrainMSE);
figure
plot (1:i ,eva);
figure
plot(1:20 ,test_target , 1:20 , test_output);

