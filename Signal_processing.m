close all
clear all

%initialize coefficients
I = [0:0.1:2];
R = 100;
%initialize noisy data
sd = [0,10,20,30,40,50]';
P_data = zeros(6,21,10); % P_data(i) = [sd,random_noise]

%initial coefficients & estimated values
linear_polyfit_coefficient = zeros(6,2,10);
linear_muldiv_coefficient = linear_polyfit_coefficient;

squre_polyfit_coefficient = zeros(6,3,10);
squre_muldiv_coefficient = squre_polyfit_coefficient;

second_polyfit_coefficient = zeros(6,3,10);
second_muldiv_coefficient = second_polyfit_coefficient;

fourth_polyfit_coefficient = zeros(6,5,10);
fourth_muldiv_coefficient = fourth_polyfit_coefficient;

linear_polyfit_value = zeros(6,21,10);
linear_muldiv_value = linear_polyfit_value;

second_polyfit_value = linear_polyfit_value;
second_muldiv_value = linear_polyfit_value;

fourth_polyfit_value = linear_polyfit_value;
fourth_muldiv_value = linear_polyfit_value;

%set up muldiv method X.*v = Y
muldiv_linear_X = ones(21,2,10);%set X [1,In,In^2, ... In^n]
muldiv_second_X = ones(21,3,10);
muldiv_fourth_X = ones(21,5,10);

muldiv_linear_v = ones(6,2,10);%set v[v0,v2,...vn]'
muldiv_second_v = ones(6,3,10);
muldiv_fourth_v = ones(6,5,10);

%initial the noisy results
for i = 1:10
    
    sd_noise = sd*randn(1,21);
%modelling measurement with noises
    P_standard = R*I.^2;
    P_noisy = P_standard + sd_noise;
    P_data(:,:,i) =P_noisy;
    
% polyfit() method    
   for k = 1:6;
   %polyfit() method
   linear_polyfit_coefficient(k,:,i) = polyfit(I,P_noisy(k,:),1);
   linear_polyfit_value(k,:,i) = polyval(linear_polyfit_coefficient(k,:,i),I);
   %squre_coefficient(k) = polyfit(I,P_noisy(k),2);
  
   second_polyfit_coefficient(k,:,i) = polyfit(I,P_noisy(k,:),2);
   second_polyfit_value(k,:,i) = polyval(second_polyfit_coefficient(k,:,i),I);
   
   fourth_polyfit_coefficient(k,:,i) = polyfit(I,P_noisy(k,:),4);
   fourth_polyfit_value(k,:,i) = polyval(fourth_polyfit_coefficient(k,:),I);
   
   
   %premutiply method
   for j = 1:21; %setup X matrices
      muldiv_linear_X(j,:,i)=[I(j),1]';
      muldiv_second_X(j,:,i)=[I(j).^2,I(j),1]';
      muldiv_fourth_X(j,:,i)=[I(j).^4,I(j).^3,I(j).^2,I(j),1];
   end
   %v = X/Y
   for m = 1:2;        
      muldiv_linear_v(k,:,i)= muldiv_linear_X(:,m,i)\P_data(k,:,i)';
      linear_muldiv_value(k,:,i)=polyval(muldiv_linear_v(k,:,i),I);
   end
   
   end
end


%polyval()
