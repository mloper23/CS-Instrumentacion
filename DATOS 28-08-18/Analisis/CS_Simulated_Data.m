%%Load data
path(path, '../Optimization');
path(path, '../Data');
path(path,'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\TwIST_v2');
Spectrum = xlsread('../Datos/Espectro OSL2');
lambda = xlsread('../Datos/Longitudes de onda');

%% Sensibility Matrix Simulated

Deltha= @(lamda,birrefringence,d)2*pi*birrefringence*d./lamda;
Samples_N = size(Spectrum,1);
birrefringence = linspace(0.05,0.2,100);
d = 1e4;
Phi = sin(Deltha(lambda,birrefringence,d)/2).^2;
Phi = Phi';
%% Measurements gi = int(Spectrum(lambda)*hi(lambda) dlambda) 
% hi(lambda) = alpha(lambda) * Phii(lambda). alpha(lambda) = 1
Measurements_g = Phi*Spectrum;

%% l2 norm previous to CS

if 0
    %Fourier transform
    Phi_transformed = ifftshift(fft(fftshift(Phi,2),[],2),2);
    Spc_transformed_l2 = pinv(Phi_transformed)*Measurements_g;
    Spc_l2 = fftshift(fft(ifftshift(Spc_transformed_l2)));
        
else
    %Wavelet transform
    for i = 1:size(Measurements_g)
        [Phi_transformed(i,:),cD(i,:)] = dwt(Phi(i,:),'coif3');
    end
 Spc_transformed_l2 = pinv(Phi_transformed)*Measurements_g;
 Spc_l2 = idwt(Spc_transformed_l2, zeros(size(Spc_transformed_l2)),'coif3');
end

%% l1 using CS
if 0
    %Using l1_magic
    Spectrum_reconstructed = l1eq_pd(Spc_transformed_l2,Phi_transformed,[],Measurements_g,1e-3);
else
    %TwIST
    hR = @(x) Phi_transformed*x;
    hRt = @(x) Phi_transformed'*x;
    
    Measurements_g = hR(Spc_transformed_l2);
    
    tau = 0.0001*max(abs(hRt(Measurements_g)));
    
    lambda1 = 0.0001;
    tolA = 1e-4;
    
    [x_twist,x_debias_twist,obj_twist,...
    times_twist,debias_start_twist,mse]= ...
         TwIST(Measurements_g,hR,tau, ...
         'Lambda', lambda1, ...
         'Debias',0,...
         'AT', hRt, ... 
         'Monotone',1,...
         'Sparse', 1,...
         'Initialization',0,...
         'StopCriterion',1,...
       	 'ToleranceA',tolA,...
         'Verbose', 1);
    Spectrum_reconstructed = idwt(x_twist, zeros(size(x_twist)),'coif3');
    plot(Spectrum_reconstructed)
    hold on
    plot(Spectrum)
end


