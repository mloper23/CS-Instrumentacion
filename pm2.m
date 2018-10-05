s = serial('COM3');
fopen(s)
s.ReadAsyncMode = 'manual';
fprintf(s,'Measurement:Meas1:Source CH1')
fprintf(s,'Measurement:Meas1:Type Pk2Pk')
fprintf(s,'Measurement:Meas1:Value?')
readasync(s)
% s.BytesAvailabledelete(instrfindall);
out = fprintf(s)
fclose(s)