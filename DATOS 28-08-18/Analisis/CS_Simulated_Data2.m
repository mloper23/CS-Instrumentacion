%%Load data
path(path, '../Optimization');
path(path, '../Data');
path(path,'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\TwIST_v2');
Spectrum = xlsread('../Datos/Espectro OSL2');
lambda = xlsread('../Datos/Longitudes de onda');
Spectrum =sin(lambda/50);
%% Sensibility Matrix Simulated

Deltha= @(lamdda,birrefringence,d)2*pi*birrefringence*d./lambda;
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

    Spc_transformed_l2= ifftshift(fft(fftshift(pinv(Phi)*Measurements_g))); 
    Spc_l2 = pinv(Phi)*Measurements_g;  
    plot(real(Spc_l2))
    
else
    %Wavelet transform
    for i = 1:size(Measurements_g)
        [Phi_transformed(i,:),cD(i,:)] = dwt(Phi(i,:),'coif3');
    end
%     Spc_transformed_l2 = pinv(Phi_transformed)*Measurements_g;
    [Spc_transformed_l2,d] = dwt(Spectrum,'coif3');
    Spc_l2 = idwt(Spc_transformed_l2, zeros(size(Spc_transformed_l2)),'coif3');
    Measurements__g = cD*d;
end


%% l1 using CS
if 0
    %Using l1_magic
    Spectrum_reconstructed = l1eq_pd(real(Spc_transformed_l2),pinv(real(Phi_transformed))',[],Measurements_g,1e-3);
else
  [x_t,x_debias,objective,times,debias_start,mses] = TwIST(Measurements_g,Phi_transformed,-1)
  [x__t,x__debias,objective,times,debias_start,mses] = TwIST(Measurements__g,cD,-1)
  
  x_reconstructed = idwt(x_t,x__t,'coif3');
  plot(x_reconstructed)
  hold on
  plot(Spectrum)
    
    
end


