close all
clear all

inner_width = 0.01; %inner square width
inner_height = inner_width;
outer_width = 0.02; %outer suqare width
outer_height = outer_width;
num_points = 10;%number of points in x-direction
error=1e-4;%error tollerance

h = 0.5*outer_height/num_points; %grid size / finite differences
num_element_inner_x = round(0.5*inner_width/h);% num of elements on inner width
num_element_inner_y = round(0.5*inner_height/h);% num of elements on inner hieght
num_element_outer_x = round(0.5*outer_width/h);% num of elements on outer width
num_element_outer_y = round(0.5*outer_height/h);%num of elements on outer height

inner_x_element = linspace(0,0.5*inner_width,num_element_inner_x); % elements in inner x-direction
inner_y_element = linspace(0,0.5*inner_height,num_element_inner_y); % elements in inner y-direction

outer_x_element = linspace(0,0.5*outer_width,num_element_inner_x); % elements in outer x-direction
outer_y_element = linspace(0,0.5*outer_height,num_element_inner_y); % elements in outer y-direction

%initialize potential and mask array

solution = zeros(num_element_outer_x+1,num_element_outer_y+1); %initialize 2-D array with 0V for outer layer condition
mask = ones(num_element_outer_x+1,num_element_outer_y+1);
%initial edge values of solution
    %initial the left edge solution        
for i = 1:num_element_inner_x+1;
    for j = 1:num_element_inner_y+1;
        solution(i,j)=1
        mask(i,j) = 0
    end
end


% for y = num_element_inner_y : num_element_outer_y+1;
%     solution(1,y) = 1;
% end
% for x = num_element_inner_x : num_element_outer_x+1;
%     solution(x,1) = 1;
% end

    

%update values of solution grid, calculate capacitance
oldcap = 0.0
for counter = 1:1000
    solution = convergence_iteration(solution,mask,num_element_outer_x,num_element_outer_y)
    cap = cal_cap(solution,h,num_element_outer_x,num_element_outer_y)
    if abs(oldcap-cap)<error
        break
    else
        oldcap=cap;
    end
end

str = sprintf('Number of iterations = %4i' , counter); 
disp(str)

function grid = convergence_iteration(grid,mask_array,x,y)
sprintf('updating grid values')
%grid = solution grid 
%x , y = num of elements in x/y direction
for i = 2:x;
    for j = 2:y;
        grid(i,j)=0.25*(grid(i-1,j)+grid(i+1,j)+grid(i,j-1)+grid(i,j+1))
        if mask_array(i,j)==0%if mask = 0, maintian the grid inner edge value unchanged
            grid(i,j)=1;
        end
    
    end
end

i = 1
for j = 2:y;
    grid(i,j)=0.25*(2*grid(i+1,j)+grid(i,j-1)+grid(i,j+1))
end

j=1
for i = 2:x;
    grid(i,j)=0.25*(grid(i-1,j)+grid(i+1,j)+2*grid(i,j+1))
end

end % end convergence_iteration()



function cap = cal_cap(solution_array,h,x,y)
sprintf('calcualte cap value')
%solution_array  = 2-d array with converged solution
% h = grid size
% x = num of points in x-direction
% y = num of points in y-direction

q = 0.0;
for i = 1:x-1
    q = q+0.5*(solution_array(i,y)+solution_array(i+1,y));% integral along upper boundary edge
end

for j = 1:y-1
    q = q+ 0.5*(solution_array(x,j)+solution_array(x,j+1));%integral along right boundaray edge
end

cap = q*4;
cap = cap*8.854187;
 
    
    
end %end cal_cap()
        
    
    
    
    
    