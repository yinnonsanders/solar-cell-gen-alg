function [ J_Test ] = OfC0( thickness,Lightprop )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


i=thickness;

%define the system architeture
System = zeros(1,1,thickness,11);
System(1,1,1:thickness,1)=2;
System(:,:,1,1)=1;
S=size(System);

t1=cputime;
System=Egen0(System,Lightprop); % 1 reflection 180 degrees

t1=cputime-t1;



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

