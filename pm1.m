s = serial('COM3');
fopen(s)
fprintf(s,'*IDN?')
idn = fprintf(s);
fclose(s)