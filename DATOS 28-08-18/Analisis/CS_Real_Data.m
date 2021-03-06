%%Load data
path(path, '../Optimization');
path(path, '../Data');
load('../Datos/MedidasPowerMeter_9.mat');
WlghAxes = xlsread('../Datos/Longitudes de onda');
Phi_measured = xlsread('../Datos/L4');
Phi_measured = Phi_measured';
Measurements_g = ourMeasurements';
% I_0 = xlsread('Espectro OSL2');

% I__0 = I_0/norm(I_0);

%% l2 norm previous to CS

if 0
    %Fourier transform
    Phi_transformed = ifftshift(fft(fftshift(Phi_measured,2),[],2),2);
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


