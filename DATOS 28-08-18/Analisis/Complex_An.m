lambda = xlsread('../Datos/Longitudes de onda');
x = xlsread('../Datos/Espectro OSL2');
path(path, 'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\TwIST_v2');
x = sin((lambda)/50);
x = x/max(x);
x = (fft(x)); 
x = [x;conj(x)];
k = 100; %Observation 
% measurement matrix
disp('Building measurement matrix...');
Deltha= @(lamdda,birrefringence,d)2*pi*birrefringence*d./lambda;
Samples_N = size(x,1);
birrefringence = linspace(0.05,0.2,100);
d = 1e4;
Phi = sin(Deltha(lambda,birrefringence,d)/2).^2;
R = Phi';
R = fft(Phi');
R = [R conj(R)];
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
y = real(hR(x));

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
     
     r = real(ifft(x(1:1024)));
     plot(r)
     hold on
     c = real(ifft(x_twist(1024:2048)));
     plot(c*10)