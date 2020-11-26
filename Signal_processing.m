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
   linear_polyfit_value(k,:,i) = polyval([linear_polyfit_coefficient(k,:,i)],I);
   
%    square_coefficient(k) = polyfit(I,P_noisy(k,:),2);
%    square_polyfit_value(k)=polyval(square_polyfit_coefficient(k),I); 
   
   second_polyfit_coefficient(k,:,i) = polyfit(I,P_noisy(k,:),2);
   second_polyfit_value(k,:,i) = polyval([second_polyfit_coefficient(k,:,i)],I);
   
   fourth_polyfit_coefficient(k,:,i) = polyfit(I,P_noisy(k,:),4);
   fourth_polyfit_value(k,:,i) = polyval([fourth_polyfit_coefficient(k,:)],I);
   
   
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
      linear_muldiv_value(k,:,i)=polyval([linear_muldiv_v(k,:,i)],I);
   end
        square_muldiv_v(k,:,i)=square_muldiv_X(:,:,i)\P_data(k,:,i)';
        square_muldiv_value(k,:,i)=polyval([square_muldiv_v(k,:,i),0,0],I);
   for m2 = 1:3;
       second_muldiv_v(k,:,i)=second_muldiv_X(:,m2,i)\P_data(k,:,i)';
       second_muldiv_value(k,:,i)=polyval([second_muldiv_v(k,:,i)],I);
   end
   for m4 = 1:5;
        fourth_muldiv_v(k,:,i)=fourth_muldiv_X(:,m4,i)\P_data(k,:,i)';
        fourth_muldiv_value(k,:,i)=polyval([fourth_muldiv_v(k,:,i)],I);
   end
   end
end

%compute the average output for 10 iterations
P_data_average = zeros(6,21);
linear_muldiv_value_average = zeros(6,21);
second_muldiv_value_average = zeros(6,21);
square_muldiv_value_average = zeros(6,21);
fourth_muldiv_value_average = zeros(6,21);

linear_polyfit_value_average = zeros(6,21);
second_polyfit_value_average = zeros(6,21);
fourth_polyfit_value_average = zeros(6,21);
for i = 1:10;
    for k = 1:6;
    P_data_average(k,:) = P_data_average(k,:)+P_data(k,:,i)/10;
    %muldiv average evaluation value
    linear_muldiv_value_average(k,:) = linear_muldiv_value_average(k,:)+linear_muldiv_value(k,:,i)/10;
    second_muldiv_value_average(k,:) = second_muldiv_value_average(k,:)+second_muldiv_value(k,:,i)/10;
    square_muldiv_value_average(k,:) = square_muldiv_value_average(k,:)+square_muldiv_value(k,:,i)/10;
    fourth_muldiv_value_average(k,:) = fourth_muldiv_value_average(k,:)+fourth_muldiv_value(k,:,i)/10;
    
    %polyfit average evaluation value
    linear_polyfit_value_average(k,:) = linear_polyfit_value_average(k,:)+linear_polyfit_value(k,:,i)/10;
    second_polyfit_value_average(k,:) = second_polyfit_value_average(k,:)+second_polyfit_value(k,:,i)/10;
    fourth_polyfit_value_average(k,:) = fourth_polyfit_value_average(k,:)+fourth_polyfit_value(k,:,i)/10;
    end 
end

%least square fit = muldiv method
linear_error = sum((linear_muldiv_value_average' - P_data_average').^2);
square_error = sum((square_muldiv_value_average' - P_data_average').^2);
second_error = sum((second_muldiv_value_average' - P_data_average').^2);
fourth_error = sum(fourth_muldiv_value_average' - P_data_average').^2);

