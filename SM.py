import Tkinter as tk
from screeninfo import get_monitors


root = tk.Tk() 
for m in get_monitors():
    print(m)


#Para una pantalla y en el centro  
w = 1366
h = 1064
ws = root.winfo_screenwidth() 
hs = root.winfo_screenheight() 
x = (ws/2) - (w/2)-7 +1366
y = -40

#Configuraciones
NG = 255 #Nivel de gris de 0 a 255
color = '#%02x%02x%02x' % (NG, NG, NG)
root.configure(bg=color)
root.geometry('%dx%d+%d+%d' % (w, h, x, y))




root.mainloop() 
