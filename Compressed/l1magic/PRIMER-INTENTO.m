path(path, './Optimization');
path(path, './Data');
%signal lenght

n(1,:) = 0:(0.1/81):(0.1-(0.1/81));
n(2,:) = 0.01+  n(1,:);
n(3,:) = 0.01 + n(2,:);

L = 400:5:800;
d = 10000;
D = zeros(3,81);
for i =1:3
    D(i,:) = (2*pi*d.*n(i,:))./L;
end
P = (sin(D./2)).^2;
plot (L,P)

% solve the LP
% tic
% xp = l1eq_pd(x0, A, [], y, 1e-3);
% toc