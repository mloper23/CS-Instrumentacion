function demo_l2_l0
x = xlsread('../Datos/Espectro OSL2');
lambda = xlsread('../Datos/Longitudes de onda');
% measurement matrix
disp('Building measurement matrix...');
Deltha= @(lamdda,birrefringence,d)2*pi*birrefringence*d./lambda;
Samples_N = size(x,1);
birrefringence = linspace(0.05,0.2,100);
d = 1e4;
Phi = sin(Deltha(lambda,birrefringence,d)/2).^2;
R = Phi';
%normalize R
%  maxSingValue=svds(R,1);
%  R=R/maxSingValue;
% R has been precomputed 
% load CSmatrix R
disp('Finished creating matrix');

%TwIST handles
% Linear operator handles 
hR = @(x) R*x;
hRt = @(x) R'*x;
% define the regularizer and the respective denoising function
Psi = @(x,th) hard(x,th);   % denoising function
Phi = @(x) l0norm(x);       % regularizer

% noise variance
sigma=  1e-2;
% observed data
y = hR(x);

%  regularization parameter 
tau = 20;

% stopping theshold
tolA = 1e-6;

% -- TwIST ---------------------------
% stop criterium:  the relative change in the objective function 
% falls below tolA
[x_twist,x_debias_twist,obj_twist,...
    times_twist,debias_start_twist,mse]= ...
         TwIST(y,hR,tau,...
         'Psi',Psi,...
         'Phi',Phi,...
         'AT', hRt, ... 
         'Initialization',0,...
         'Monotone', 1, ...
         'StopCriterion',1,...
       	 'ToleranceA',tolA,...
         'Verbose', 1);
     plot(x_twist)
     hold on
     plot(x)





