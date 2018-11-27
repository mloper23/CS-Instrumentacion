
lambda = xlsread('../Datos/Longitudes de onda');
x = xlsread('../Datos/Espectro OSL2');
path(path, 'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\TwIST_v2');
x = sin((lambda)/50);
% x = 1;
% x = x/max(x);
x = fft(x);
 

% measurement matrix
disp('Building measurement matrix...');
Deltha= @(lamdda,birrefringence,d)2*pi*birrefringence*d./lambda;
Samples_N = size(x,1);
birrefringence = linspace(0.05,0.2,100);
d = 1e4;
Phi = sin(Deltha(lambda,birrefringence,d)/2).^2;
R = Phi';
% R = fft(Phi');

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


% observed data
y = real(hR(x));

[x_t,x_debias,objective,times,debias_start,mses] = TwIST(y,R,0.005)


     
     plot(real(ifft(x)))
     hold on 
     plot((x_t))

    


