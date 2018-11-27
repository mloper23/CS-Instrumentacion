
I=sqrt(-1);
path(path, 'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\TwIST_v2');
n = 1024;
k = 256;
lambda = 1:n;

r = 1; %Si es 1 usamos Wavelet, si es 0, solo con transformada de Fourier
a = 1; %Si es 1 usamos el espectro medido, si es 0 usamos una función
if a
    %Espectro real
    x = xlsread('../Datos/Espectro OSL2');
else
    x = cos(lambda/50);
    x = x';
end
x = x/max(x);
x = (fft(x));
x=[x;conj(x)];

%Matriz de sensibilidad simulada
l=(0:n-1)*2*pi/2/n;
T=(0:k-1)';
Z=exp(I*T*l);
R = [Z conj(Z)];

if r
    %Matrices para wavelet
    [x, xD] = dwt(real(x),'coif3');
    Z=R;
    for i = 1:41
        [R(i,:),RD(i,:)] = dwt(real(Z(i,:)),'coif3');
    end
else
end

hR = @(x) R*x;
hRt = @(x) R'*x;
Psi = @(x,th) soft(x,th);   % denoising function
Phi = @(x)    sum(abs(x(:)));     % regularizer
sigma=1e-3;
y = real(hR(x));
tau=0.05*max(abs(hRt(y))); 
tolA = 1e-6;

 [x_twist,x_debias_twist,obj_twist,...
    times_twist,debias_start_twist,mse]= ...
    TwIST(y,hR,tau,...
    'Debias', 0 , ...
    'AT', hRt, ...
    'Initialization',randn(size(x)),...
    'StopCriterion',1,...
    'ToleranceA',tolA,...
    'Verbose', 1);


if r
    %     Wavelet Solution
    hR_ = @(x) RD*x;
    hRt_ = @(x) RD'*x;
    y_ = real(hR_(xD));
    [x__twist,x_debias_twist,obj_twist,...
        times_twist,debias_start_twist,mse]= ...
        TwIST(y_,hR_,tau,...
        'Debias', 1 , ...
        'AT', hRt_, ...
        'Initialization',randn(size(x)),...
        'StopCriterion',1,...
        'ToleranceA',tolA,...
        'Verbose', 1);
    x_original = idwt(x,xD,'coif3');
    x_original= real(ifft(x_original(1:1024)));
    plot(x_original)
    
    hold on
    x_reconstr = idwt(x_twist,x__twist,'coif3');
    x_reconstr = real(ifft(x_reconstr(1:1024)));
    plot(x_reconstr)
else
    plot(abs(ifft(x(1:1024))));
    hold on
    plot(abs(ifft(x_twist(1:1024))));
    
end




