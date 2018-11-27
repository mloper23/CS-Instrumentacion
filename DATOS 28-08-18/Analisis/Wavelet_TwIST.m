path(path, 'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\TwIST_v2');
x = xlsread('../Datos/Espectro OSL2');
[x, cD] = dwt(x,'coif3');
% signal length 
n = 1024;
% observation length 
k = 41;

% measurement matrix
disp('Building measurement matrix...');
Z = randn(k,n);
    for i = 1:41
        [R(i,:),cL(i,:)] = dwt(Z(i,:),'coif3');
    end

%TwIST handlers
% Linear operator handlers
hR = @(x) R*x;
hRt = @(x) R'*x;
% define the regularizer and the respective denoising function
% TwIST default
Psi = @(x,th) soft(x,th);   % denoising function
Phi = @(x) l1norm(x);       % regularizer

% noise variance
sigma=1e-2;
% observed data
y = hR(x)+sigma*randn(k,1);

% regularization parameter 
tau = 0.1*max(abs(hRt(y)));

% TwIST parameters
lambda1 = 0.001;  

%             If min eigenvalue of A'*A == 0, or unknwon,  
%             set lam1 to a value much smaller than 1. 
%             TwIST is not very sensitive to this parameter
%             
%
%             Rule of Thumb: 
%                 lam1=1e-4 for severyly ill-conditioned problems
%                 lam1=1e-2 for mildly  ill-conditioned problems
%                 lam1=1    for A unitary direct operators



% stopping theshold
tolA = 1e-15;

% -- TwIST ---------------------------
% stop criterium:  the relative change in the objective function 
% falls below 'ToleranceA'
[x_twist,x_debias_twist,obj_twist,...
    times_twist,debias_start_twist,mse]= ...
         TwIST(y,hR,tau, ...
         'Lambda', lambda1, ...
         'Debias',0,...
         'AT', hRt, ... 
         'Monotone',1,...
         'Sparse', 1,...
         'Initialization',0,...
         'StopCriterion',1,...
       	 'ToleranceA',tolA,...
         'Verbose', 1);
   





