%%Carga de los datos
path(path,'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\DATOS 28-08-18\Optimization');
path(path, 'C:\Users\USER.DESKTOP-T7S4BCO\Desktop\VI\Instrumentación\TwIST_v2');

%%
%Parámetros
if 0 %Usando la base cdt, funciones periodicas.
    t = 0:6e-06:0.03-6e-6;
    f = sin(1394*pi*t)+sin(3266*pi*t); %Función a reconstruir
%     f = sin(300*t);
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
%     b = A*f';
    f0 = A'*b;
    
else 
    Spectrum = xlsread('../Datos/Espectro OSL2');
    f = Spectrum';
    f = f/max(f);
    c = ifft(f);
    [m,n]= size(f);    
    k = randi(1024,1,300);
    q = zeros(1,n);
    q(k) = f(k);
    W = eye(n,n);
%     for i=1:n
%         [Phii c] = dwt(W(i,:),'coif3'); %La base que voy a usar!
%         Phii(i,:) = Phii;
%     end
%     Phii = Phii';
%     [m,n]= size(Phii);
%     k = randi(round(m),1,round(m/10));
    if 0
        Phii = dct(eye(n,n),n ,1);
        A = Phii(k,:);
        b = f(k)';
    %     b = A*f';
        f0 = A'*b;
    else
        %Wavelet transform
%         [f, ff] = dwt(f,'coif3');
        I = eye(n,n);
        for i = 1:n
            [Phi_transformed(i,:),cD(i,:)] = dwt(I(i,:),'coif3');
        end
        Phii = Phi_transformed;
        A = Phi_transformed(k,:);
        b = f(k)';
        f0 = A'*b;
    end
    
end
    
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
    f1 = l1eq_pd(f0,A,[],b,1e-8,50,2e3);
    f_rec = Phii*f1;
    plot(f)
    hold on
    plot(f_rec)
%     
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
     
 