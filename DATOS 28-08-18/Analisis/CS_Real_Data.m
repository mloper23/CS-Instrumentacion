%%Load data
path(path, './Optimization');
path(path, './Data');

load('MedidasPowerMeter_9.mat');
WlghAxes = xlsread('Longitudes de onda');
Phi_measured = xlsread('L4');
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
% Phi_transformed = bsxfun(@(x)cwt(x),Phi_measured(1,:));
% Phi_transformed = zeros(size(Phi_measured));
for i = 1:size(ourMeasurements,2)
    [Phi_transformed(i,:),n] = dwt(Phi_measured(i,:),'sym1');  
end
Spc_transformed_l2 = pinv(Phi_transformed)*Measurements_g;
Spc_l2 = idwt(Spc_transformed_l2,0,'sym1');


end