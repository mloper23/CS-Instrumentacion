path(path, './Optimization');
path(path, './Data');
load('MedidasPowerMeter_9.mat')
L = xlsread('Longitudes de onda');
I_0 = xlsread('Espectro OSL2');
I__0 = I_0/norm(I_0);
L4 = xlsread('L4');
A = L4'; %A es los valores que tomamos. 
A = A/norm(A); %A normalizada
x = ((sin(L/20).^2)./L)';
% x = sparse(x);
% A = A./I_0';
A = A./A(1,:);
% A = orth(A')';
% y = A*x';
% A = ifftshift(fft(fftshift(A,2),[],2),2);

% for q = 1:1024
%     f(q) = (sin(L(q)/100).^4)/L(q);
% %     f(q) = (besselj(3,L(q)/20)).^6;
%  end
% x =f; 


y = ourMeasurements';

% initial guess = min energy
x0 = pinv(A)*y;
X0 = fftshift(fft(ifftshift(x0)));
% x0 = x0/max(x0);
% 
% % solve the LP
tic
xp = l1eq_pd(x0, A, [], y, 1e-3) ;
toc




plot(L,xp,L,x)


