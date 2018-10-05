L = 400:2:800;
f = besselj(1,L/15).*L/100; %una función arbitraria de entrada
% plot(L,f, 'LineWidth',1.5)
d = 13000;
a = 201; %cantidad de muestras
n(a,:) = -0.200:0.002:0.200;
for i = 1:a
    n(i+1,:) = n(i,:)+0.01;
end
for i =1:a
    D(i,:) = (2*pi*d.*n(i,:))./L;
end

P = (sin(D./2)).^2; %matriz de retardo tiene que ser cuadrada(???????????)

g = P*f';
fr = g\P;
plot(L,(fr)*100,L,f)
% plot(L,D)
% plot(L,P(10,:),L,P(15,:),L,P(20,:))
