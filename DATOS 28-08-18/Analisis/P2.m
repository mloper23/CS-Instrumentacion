
%importar los paquetes de optimización
path(path, '../Optimization');
path(path, '../Data');
load('../Datos/MedidasPowerMeter_9.mat');
%creo el vector de longitudes de onda
L = 400:0.3906:800-0.3906;

%aquí cree una función de entrada
for q = 1:1024
    f(q) = (sin(L(q)/100).^2+1)/L(q);
%     f(q) = (besselj(3,L(q)/20)).^6;
 end

x = sparse(f);

%mi matriz característica, teórica
disp('Creating measurment matrix...');
n = 0:0.0175:0.7;

d = 10000;
D = zeros(41,1024);
for i =1:41
    D(i,:) = (2*pi*d.*n(i))./L;
end
Q = (sin(D./2)).^2;
A = orth(Q');
disp('Done.');

% este seria el vector de datos que yo tomo
y = A'*x';
% y = ourMeasurements;

% debo hallar una energia inicial
x0 = A*y;
% x0 = A'*y';

% resuelvo el sistema con l1-magic
tic
xp = l1eq_pd(x0, A', [], y, 1e-3);
% xp = l1eq_pd(x0, A, [], y', 1e-3);
% xp = xp/max(xp);
toc

%large scale
% Afun = @(z) A*z;
% AtAfun = @(z) A'*z;
% tic
% xp = l1eq_pd(x0, Afun, Atfun, y, 1e-3, 30, 1e-8, 200);
% toc

%grafico
plot(L,x,L,xp)

