close all
clear all



%initialize coefficients
I = [0:0.1:2];
R = 100;
%initialize noisy data
sd = [0,10,20,30,40,50]';
P_data = zeros(6,21,10); % P_data(i) = [sd,random_noise]


%initial coefficients & estimated values
linear_polyfit_coefficient = zeros(6,2);
%sqaure_polyfit_coefficient = zeros(6,3);
second_polyfit_coefficient = zeros(6,3);
fourth_polyfit_coefficient = zeros(6,5);


linear_polyfit_value = zeros(6,21); %polyval output from polyfit method 
linear_mldiv_value = linear_polyfit_value;%polyval output from muldiv method

% square_polyfit_value = linear_polyfit_value;
square_mldiv_value = linear_polyfit_value;

second_polyfit_value = linear_polyfit_value;
second_mldiv_value = linear_polyfit_value;

fourth_polyfit_value = linear_polyfit_value;
fourth_mldiv_value = linear_polyfit_value;

%set up muldiv method X.*v = Y
linear_mldiv_X = ones(21,2);%set X [1,In,In^2, ... In^n]
square_mldiv_X = ones(21,1);
second_mldiv_X = ones(21,3);
fourth_mldiv_X = ones(21,5);

linear_mldiv_v = ones(6,2);%set v[v0,v2,...vn]'
square_mldiv_v = ones(6,1);
second_mldiv_v = ones(6,3);
fourth_mldiv_v = ones(6,5);

P_average = zeros(6,21);
%initial the noisy results
for i = 1:10
    
    sd_noise = sd*randn(1,21);
%modelling measurement with noises
    P_standard = R*I.^2;
    P_noisy = P_standard + sd_noise;
    P_data(:,:,i) =P_noisy;
    for k = 1:6;
    P_average(k,:) = P_average(k,:)+P_data(k,:,i)/10;
    end
end

%fitting data 
% polyfit() method    
   for k = 1:6;
   %polyfit() method
   linear_polyfit_coefficient(k,:) = polyfit(I,P_average(k,:),1);
   linear_polyfit_value(k,:) = polyval([linear_polyfit_coefficient(k,:)],I);
   
%    square_coefficient(k) = polyfit(I,P_noisy(k,:),2);
%    square_polyfit_value(k)=polyval(square_polyfit_coefficient(k),I); 
   
   second_polyfit_coefficient(k,:) = polyfit(I,P_average(k,:),2);
   second_polyfit_value(k,:) = polyval([second_polyfit_coefficient(k,:)],I);
   
   fourth_polyfit_coefficient(k,:) = polyfit(I,P_average(k,:),4);
   fourth_polyfit_value(k,:) = polyval([fourth_polyfit_coefficient(k,:)],I);
   
   
   %premutiply method
   for j = 1:21; %setup X matrices
      linear_mldiv_X(j,:)=[I(j),1];
      square_mldiv_X(j,:)=[I(j).^2];
      second_mldiv_X(j,:)=[I(j).^2,I(j),1];
      fourth_mldiv_X(j,:)=[I(j).^4,I(j).^3,I(j).^2,I(j),1];
   end
   
   
   %v = X/Y
  
      linear_mldiv_v(k,:)= linear_mldiv_X(:,:)\P_average(k,:)';
      linear_mldiv_value(k,:)=polyval([linear_mldiv_v(k,:)],I);

        square_mldiv_v(k,:)=square_mldiv_X(:,:)\P_average(k,:)';
        square_mldiv_value(k,:)=polyval([square_mldiv_v(k,:),0,0],I);

       second_mldiv_v(k,:)=second_mldiv_X(:,:)\P_average(k,:)';
       second_mldiv_value(k,:)=polyval([second_mldiv_v(k,:)],I);
 
        fourth_mldiv_v(k,:)=fourth_mldiv_X(:,:)\P_average(k,:)';
        fourth_mldiv_value(k,:)=polyval([fourth_mldiv_v(k,:)],I);
   
   
 end

%compute errors for least square fitting
mldiv_linear_error = sum((linear_mldiv_value' - P_average').^2)';
mldiv_square_error = sum((square_mldiv_value' - P_average').^2)';
mldiv_second_error = sum((second_mldiv_value' - P_average').^2)';
mldiv_fourth_error = sum((fourth_mldiv_value' - P_average').^2)';

polyfit_linear_error = sum((linear_polyfit_value' - P_average').^2)';
polyfit_second_error = sum((second_polyfit_value' - P_average').^2)';
polyfit_fourth_error = sum((fourth_polyfit_value' - P_average').^2)';


%plot the fitting result
k=6;
figure;
h1=plot(I,second_polyfit_value(k,:),'m', I,fourth_mldiv_value(k,:),'r',I,P_average(k,:),'*');
hold on
legend(h1,"Second Order Model","Fourth Order Model"," Refernece Data");
p=poly2sym(linear_mldiv_v(1,:));
xlabel("Current I");
ylabel("Calculated Power");
title("Mildive() fitting with SD = 50")

 %calculate the contribution factor
fourth_x_4_contribution_20 = abs(fourth_polyfit_coefficient(3,1)*I.^4);
fourth_x_3_conribution_20 = abs(fourth_polyfit_coefficient(3,2)*I.^3);
fourth_x_2_conribution_20 = abs(fourth_polyfit_coefficient(3,3)*I.^2);
fourth_x_1_conribution_20 = abs(fourth_polyfit_coefficient(3,4)*I.^1);
fourth_x_0_conribution_20 = abs(fourth_polyfit_coefficient(3,1)*I^.0);



% for d = 1:6
%     eqn(d,:) =poly2sym(square_mldiv_v(d,:));
% end    


%h2 = plot(I,linear_mldiv_value(1,:),'r',I,linear_polyfit_value(1,:),'b');

