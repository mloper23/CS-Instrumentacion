%%Load data
path(path, '../Optimization');
path(path, '../Data');
Spectrum = xlsread('../Datos/Espectro OSL2');
lamda = xlsread('../Datos/Longitudes de onda');

%% Sensibility Matrix Simulated

Deltha= @(lamda,birrefringence,d)2*pi*birrefringence*d./lamda;
Samples_N = size(Spectrum,1);
birrefringence = linspace(0.05,0.2,100);
d = 1e4;
Phi = sin(Deltha(lamda,birrefringence,d)/2).^2;
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
        [cA(i,:),cD(i,:)] = dwt(Phi(i,:),'coif3');
    end
 Spc_transformed_l2 = pinv(cA)*Measurements_g;
 Spc_l2 = idwt(Spc_transformed_l2, zeros(size(Spc_transformed_l2)),'coif3');
end

%% l1 using CS
if 1
    %Using l1_magic
%     Phi_transformed = orth(Phi_transformed);
%     Phi_transformed = orth(abs(Phi_transformed'));
    Spectrum_reconstructed = l1eq_pd(Spc_transformed_l2,cA,[],Measurements_g,1e-3);
else
    
end


