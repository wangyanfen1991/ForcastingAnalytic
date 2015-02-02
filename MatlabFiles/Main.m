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

usedDataSets = dataSet(1:112 , :);
testDataSets = dataSet(113:142 , :);


%% Initialized weights and other parameters
numberOfEpoch = 200;

hiddenNeruns = 25;
rand('state',7);

W1 = rand(77 , hiddenNeruns);
W2 = rand(hiddenNeruns ,1  );
W1b = rand(1, hiddenNeruns );
W2b = rand(1,1 );
G1 = rand( 1,hiddenNeruns)*2 -1;

eta = 0.02;
gamma = 0.01;
eta1(1:77,1:hiddenNeruns) = 0.02;
eta2(1:hiddenNeruns,1:1) = 0.02;
eta1b(1:1,1:hiddenNeruns) = 0.02;
eta2b(1:1,1:1) = 0.02;
etaG(1:hiddenNeruns) = 0.02;

delta2 =0;
delta1(1:1 , 1:hiddenNeruns) =0;


%% Main loop for each Epoch

for i = 1: numberOfEpoch
   %% make train and eval data
   usedDataSets = usedDataSets(randperm(end),:);
   trainDataSets = usedDataSets(1:112 , :);
   evalDataSets = usedDataSets(90:112 , :);
   
   %% Satrt each Epoch
   e=0;
   eval_error=0;
   for j=1 : 112
       % ********************************
       % define input and output
       %*********************************
       input = trainDataSets(j , 1:77 );
       output = trainDataSets (j , 78);
       
       %% Learning with Train data
       %*********************************
       % FeedForward
       %*********************************
       net1 = input * W1 + W1b;
       O1 = logsig(net1);%BipolarSigmoid(net1 , G1);
       net2 = O1 * W2 + W2b ;
       O2 = purelin( net2);
       
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
       
       %********<Train bias >***********
       W1b = W1b + eta1b .* delta1;
       W2b = W2b + eta2b * delta2;
       
       %sigma1 = error;
       %sigma2 = delta2 * W2' .* d_BipolarSigmoid(net1 , G1);
       
       %********< Train G >*************
      % G1 = G1 + etaG * sigma1;
       
       %*******< Train eta >************
       for k = 1: 16
            for m=1: 20 
                eta1(k,m )= eta1(k,m) - gamma *((input(1,k)*delta1(1,m))*(input(1,k)*delta1Before(1,m)));
            end
       end
       for k = 1: 20
            for m=1: 1 
                eta2(k,m )= eta2(k,m) - gamma *((O1(1,k)*delta2(1,m))*(O1(1,k)*delta2Before(1,m)));
            end
       end
       
       %*********************************
       % Finish Training
       %*********************************
   end
   
   trainMSEerror = mse(e);
   
   
   %% Eval Trainig
   for j =1 : 22
    % ********************************
    % define input and output
    %*********************************
    input = evalDataSets(j , 1:77 );
    output = evalDataSets (j , 78);
    
    %**********************
    % EvalFeedForward
    %**********************
    net1 = input * W1 + W1b;
    O1 = logsig(net1);%BipolarSigmoid(net1 , G1);
    net2 = O1 * W2 + W2b ;
    O2 = purelin( net2);

    eval_error(j) = (output - O2);
       
   end
   
   EvalMSEerror = mse(eval_error);
   eva(i) = EvalMSEerror;
   
    %*********************************
    % Finish Evaluating
    %*********************************
    
end


%% Test
for( j =1 : 30  )
    % ********************************
    % define input and output
    %*********************************
       input = testDataSets(j , 1:77 );
       output = testDataSets(j , 78);
       
    %*********************************
    % TestFeedForward
    %*********************************  
       net1 = input * W1 + W1b;
       O1 = logsig(net1);%BipolarSigmoid(net1 , G1);
       net2 = O1 * W2 + W2b ;
       O2 = purelin( net2);
    
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
plot(1:112 , e);
figure
plot (1:i ,eva);
figure
plot (1:30 ,test_error);
figure
plot(1:30 ,test_target , 1:30 , test_output);

