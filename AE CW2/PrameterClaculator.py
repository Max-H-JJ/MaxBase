from typing import OrderedDict
import numpy as np
import math

Ws_loss = 14
Wc_loss = 0.5
fs = 6*10**9
fc = 4.7*10**9
Wc = 2*math.pi*fc
Ws = 2*math.pi*fs

Zoc = 20 # Capacitor Impedance
Zol = 120  # Inductor Impedance
Z_0 = 50 # charateristic Impedance

def order_cal (Ws,Wc,Ws_loss,Wc_loss):
    loss = Ws_loss+Wc_loss
    fre_scal = 20*math.log10(Ws/Wc)
    N = loss/fre_scal
    return N


def g_cal (order):
    g = np.ones((order),dtype= float)
    g[0]=1    
    for i in range(1,order+1):
        g[i-1]=2*math.sin(((2*i-1)*math.pi)/(2*order))
    return g

def lumped_array(g,Z,W):
    lumped_ele = np.ones((len(g)),dtype=float)
    for i in range(0,len(g)):
        if (i+1)%2 == 0: # even for C odd for L
            lumped_ele[i]=  g[i]/(Z*W)
        else:
            lumped_ele[i] = (Z*g[i])/W
    return lumped_ele

def electrical_length_cal(g,Zoc,Zol):
    num = len(g)
    elec_length = np.zeros((g.shape),dtype=float)
    for i  in range(0,num):
        if (i+1)%2 == 0: #even number for capacitor
            elec_length[i]= g[i]*Zoc
        else: #odd number for inductor
            elec_length[i]= g[i]/Zol
    return elec_length


order = round(order_cal(Ws,Wc,Ws_loss,Wc_loss))

g_array = g_cal(order)
elec_length = electrical_length_cal(g_array,Zoc,Zol)
lump_array = lumped_array(g_array,Z_0,Wc)

print("Minimum Order: \n",order)
print("g-array:\n",g_array)
print("lumped element : \n",lump_array)
print("Electrical Length: \n",elec_length)
print("Electrical Length in Degree: \n",elec_length * 180/math.pi)

