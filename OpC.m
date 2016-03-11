function [ System ] = OpC(thickness,H,System )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

thickness=400;
H=100;
i=thickness;

%define the system architeture
   System = zeros(1,1,thickness,11);
   System(:,:,1,1)=1; 
   System(50,50,1:H,1)=1;
   S=size(System);
   
t1=cputime;
System=Egen1(System,Lightprop); % 1 reflection 180 degrees
t1=cputime-t1;

    t2 = cputime;
 System = breadth_first1(System);
 t2 = cputime-t2;
   
    t3 = cputime;
 System = collection_zone_spherical(System);
 t3 = cputime-t3;

N=collect_e(System);

%Compute the short circut current for 1 cm^2 surface area
N=sum(System(1,1,:,2));
e=1.6*10^-16; %mah
A=10^-7*10^-7;%there was no fix for 5nm cube yet 
J_energized=N*e/A;

if i<300
  %Compute the short circut current for 1 cm^2 surface area
N=sum(System(1,1,1:i,2));
e=1.6*10^-16; %mah
A=10^-7*10^-7;%there was no fix for 5nm cube yet 
J_collected=N*e/A;
end


if i>=300
%Compute the short circut current for 1 cm^2 surface area
N=sum(System(1,1,1:300,2));
e=1.6*10^-16; %mah
A=10^-7*10^-7;%there was no fix for 5nm cube yet 
J_collected=N*e/A;
end



  J_Test(1)=J_energized;
  J_Test(2)=J_collected;
  
  
end

