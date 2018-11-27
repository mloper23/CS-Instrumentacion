%%Carga de los datos
path(path,'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\DATOS 28-08-18\Optimization');
path(path, 'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\TwIST_v2');

%%
%Parámetros
t = 0:6e-06:0.03-6e-6;
f = sin(1394*pi*t)+sin(3266*pi*t); %Función a reconstruir
f = f/max(f);
[m,n]= size(f);
k = randi(n,1,n/10);
q = zeros(1,n);
q(k) = f(k);
c = idct(f);
% plot(c)
Phii = dct(eye(n,n));
A = Phii(k,:);
b = f(k)';
% b = A*f';
f0 = A'*b;
if 0
    plot(t,f)
    hold on
    scatter(t,q)
    pause(1)
    close
else 
    
end

if 1
    a = norm(A*f0-b)/norm(b);
    f1 = l1eq_pd(f0,A,[],b,1e-3,50,1);
    f_rec = Phii*f1;
    
else
    x=f';
    hR = @(x) A*x;
    hRt = @(x) A'*x;
    % define the regularizer and the respective denoising function
    Psi = @(x,th) hard(x,th);   % denoising function
    Phi = @(x) l0norm(x);       % regularizer
    
    % noise variance
    sigma=  1e-2;
    % observed data
    y = hR(x);
    
    %  regularization parameter
    tau = 0.05;
    
    % stopping theshold
    tolA = 1e-6;
    
    % -- TwIST ---------------------------
    % stop criterium:  the relative change in the objective function
    % falls below tolA
    [x_twist,x_debias_twist,obj_twist,...
        times_twist,debias_start_twist,mse]= ...
        TwIST(y,hR,tau,...
        'Psi',Psi,...
        'Phi',Phi,...
        'AT', hRt, ...
        'Initialization',0,...
        'Monotone', 1, ...
        'StopCriterion',1,...
        'ToleranceA',tolA,...
        'Verbose', 1);
    plot(x_twist)
    
end
     
 