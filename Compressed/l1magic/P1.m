path(path, './Optimization');
path(path, './Data');
%signal lenght

n = 0:0.001:0.6;

L = 400:5:800;
d = 10000;
D = zeros(3,81);
for i =1:61
    D(i,:) = (2*pi*d.*n(i))./L;
end
P = (sin(D./2)).^2;
for q = 1:81
    f(q) = (sin(L(q)).^2/L(q));
end

y = D*f';
f0 = D'*y;


% solve the LP
tic
fp = l1eq_pd(f0, D, [], y, 1e-3);
toc