close all
clear all

%initialize coefficients
I = [0:0.1:2];
R = 100;
a = R;
b = R;
c = R;
d = R;
e = R;
%initialize noises

sd = [0,10,20,30,40,50]';
P_data = zeros(6,21,10); % P_data(i) = [sd,random_noise]
%initial the noisy results
for i = 1:10
    
    sd_noise = sd*randn(1,21);
%modelling measurement with noises
    P_standard = R*I.^2;
    P_noisy = P_standard + sd_noise;

    P_data(:,:,i) =P_noisy;
end

%polyfit()
%polyval()
