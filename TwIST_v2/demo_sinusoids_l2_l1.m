
I=sqrt(-1);

% signal length 
n = 1024;
% observation length 
k = 256;


% number of spikes
n_spikes = 10;
% spikes of amplitude 1 and uniform phase in [-pi,pi[
x = zeros(n,1);
q = randperm(n);
x(q(1:n_spikes)) = sign(randn(n_spikes,1)).* ...
                         exp(I*2*pi*rand(n_spikes,1));
lambda = 1:n;
x = sin((lambda)/20);
x = x/max(x);
x = (fft(x)); 
x = x';
x=[x;conj(x)];


% measurement matrix
disp('Building measurement matrix...');
% define frequencies
W=(0:n-1)*2*pi/2/n;

% define time observations
T=(0:k-1)';
R=exp(I*T*W);

% make [A A*]
R = [R conj(R)];

%normalize R
% maxSingValue=svds(R,1);
% R=R/maxSingValue;
% % R has been precomputed 
%load CSmatrix
disp('Finished creating matrix');

%TwIST handlers
% Linear operator handlers
hR = @(x) R*x;
hRt = @(x) R'*x;
% define the regularizer and the respective denoising function
% TwIST default
Psi = @(x,th) soft(x,th);   % denoising function
Phi = @(x)    sum(abs(x(:)));     % regularizer

% noise variance
sigma=1e-3;
% observed data
y = real(hR(x))+sigma*randn(k,1);

% regularization parameter 
tau=0.5*max(abs(hRt(y))); %  strong regularization


% stopping theshold
tolA = 1e-5;

% -- TwIST ---------------------------
% stop criterium:  the relative change in the objective function 
% falls below 'ToleranceA'
[x_twist,x_debias_twist,obj_twist,...
    times_twist,debias_start_twist,mse]= ...
        TwIST(y,hR,tau,...
         'Debias', 1 , ...
         'AT', hRt, ... 
         'Initialization',randn(size(x)),...
         'StopCriterion',1,...
       	 'ToleranceA',tolA,...
         'Verbose', 1);
x = real(ifft(x(1:1024)));
plot(x)
hold on
x_t = real(ifft(x_twist(1:1024)));
plot(x_t*2.2)



