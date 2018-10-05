from sympy import *
from mpmath import *
import math
mp.dps = 25; mp.pretty = True
from sympy import plot,Symbol, sin, integrate
x = Symbol('x') #x va a ser lambda
n = Symbol('n')
d = Symbol('d')
f = (sin(x))**2/x**2
plot(f,(f,-100,100),(x,400,800))
delt =  (2*math.pi*n*d)/x
phi = (sin(delt/2))**2
a = f*phi
g = integrate(phi,x)