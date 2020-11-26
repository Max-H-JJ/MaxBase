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
sqaure_polyfit_coefficient = zeros(6,3,10);
second_polyfit_coefficient = zeros(6,3,10);
fourth_polyfit_coefficient = zeros(6,5,10);


linear_polyfit_value = zeros(6,21,10); %polyval output from polyfit method 
linear_muldiv_value = linear_polyfit_value;%polyval output from muldiv method

square_polyfit_value = linear_polyfit_value;
square_muldiv_value = linear_polyfit_value;
second_polyfit_value = linear_polyfit_value;
second_muldiv_value = linear_polyfit_value;

fourth_polyfit_value = linear_polyfit_value;
fourth_muldiv_value = linear_polyfit_value;

%set up muldiv method X.*v = Y
linear_muldiv_X = ones(21,2,10);%set X [1,In,In^2, ... In^n]
square_muldiv_X = ones(21,1,10);
second_muldiv_X = ones(21,3,10);
fourth_muldiv_X = ones(21,5,10);

linear_muldiv_v = ones(6,2,10);%set v[v0,v2,...vn]'
square_muldiv_v = ones(6,1,10);
second_muldiv_v = ones(6,3,10);
fourth_muldiv_v = ones(6,5,10);

%muldiv method output
muldiv_linear_average_output = ones(6,21);
muldiv_squre_average_output = ones(6,21);
muldiv_second_average_output = ones(6,21);
muldiv_fourth_average_output = ones(6,21);

%polyfit method output
polyfit_linear_average_output = ones(6,21);
polyfit_squre_average_output = ones(6,21);
polyfit_second_average_output = ones(6,21);
polyfit_fourth_average_output = ones(6,21);

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
   
%    square_coefficient(k) = polyfit(I,P_noisy(k,:),2);
%    square_polyfit_value(k)=polyval(square_polyfit_coefficient(k),I); 
   
   second_polyfit_coefficient(k,:,i) = polyfit(I,P_noisy(k,:),2);
   second_polyfit_value(k,:,i) = polyval(second_polyfit_coefficient(k,:,i),I);
   
   fourth_polyfit_coefficient(k,:,i) = polyfit(I,P_noisy(k,:),4);
   fourth_polyfit_value(k,:,i) = polyval(fourth_polyfit_coefficient(k,:),I);
   
   
   %premutiply method
   for j = 1:21; %setup X matrices
      linear_muldiv_X(j,:,i)=[I(j),1]';
      square_muldiv_X(j,:,i)=[I(j).^2];
      second_muldiv_X(j,:,i)=[I(j).^2,I(j),1]';
      fourth_muldiv_X(j,:,i)=[I(j).^4,I(j).^3,I(j).^2,I(j),1];
   end
   %v = X/Y
   for m1 = 1:2;        
      linear_muldiv_v(k,:,i)= linear_muldiv_X(:,m1,i)\P_data(k,:,i)';
      linear_muldiv_value(k,:,i)=polyval(linear_muldiv_v(k,:,i),I);
   end
        square_muldiv_v(k,:,i)=square_muldiv_X(:,:,i)\P_data(k,:,i)';
        square_muldiv_value(k,:,i)=polyval(square_muldiv_v(k,:,i),I);
   for m2 = 1:3;
       second_muldiv_v(k,:,i)=second_muldiv_X(:,m2,i)\P_data(k,:,i)';
       second_muldiv_value(k,:,i)=polyval(second_muldiv_v(k,:,i),I);
   end
   for m4 = 1:5;
        fourth_muldiv_v(k,:,i)=fourth_muldiv_X(:,m4,i)\P_data(k,:,i)';
        fourth_muldiv_value(k,:,i)=polyval(fourth_muldiv_v(k,:,i),I);
   end
 %compute the average evaluated output
   muldiv_linear_average_output(k,:) = sum(linear_muldiv_value(:,:,i))/10;
   muldiv_squre_average_output(k,:)= sum(square_muldiv_value(:,:,i))/10;
   muldiv_second_average_output(k,:)= sum(second_muldiv_value(:,:,i))/10;
   muldiv_fourth_average_output(k,:)= sum(fourth_muldiv_value(:,:,i))/10;
   
   polyfit_linear_average_output(k,:) = sum(linear_polyfit_value(:,:,i))/10;
   polyfit_squre_average_output(k,:)= sum(square_polyfit_value(:,:,i))/10;
   polyfit_second_average_output(k,:)= sum(second_polyfit_value(:,:,i))/10;
   polyfit_fourth_average_output(k,:)= sum(fourth_polyfit_value(:,:,i))/10;  
   end
end
%compute error
%muldiv_linear_error = sum(muldiv_linear_average_output)/6;



%polyval()
