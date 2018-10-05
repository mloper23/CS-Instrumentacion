%ABRIR el puerto COM3 
clc; 
% disp('BEGIN') 
% SerPIC = serial('COM3'); 
% set(SerPIC,'BaudRate',9600); 
% set(SerPIC,'DataBits',8); 
% set(SerPIC,'Parity','none'); 
% set(SerPIC,'StopBits',1); 
% set(SerPIC,'FlowControl','none'); 
% fopen(SerPIC); 
%*-*-*-*-*-*- 
%Para leer los datos del puerto se usa la función fscanf. 
s1 = serial('COM3'); 
set(s1,'BaudRate',9600); 
set(s1,'DataBits',8); 
set(s1,'Parity','none'); 
set(s1,'StopBits',1); 
set(s1,'FlowControl','software'); 
set(s1,'Terminator','CR');
set(s1, 'TimeOut', 1)
fopen(s1); 
fscanf(s1) 
% pause(2);
%CERRAR el puerto COM1 al finalizar 
fclose(s1); 
delete(s1) 
disp('STOP') 
%delete(instrfindall); por si no cierra

%Probar lo de tmtool