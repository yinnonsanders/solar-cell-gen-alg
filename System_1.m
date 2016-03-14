%Define the System 
global System
System = zeros(100,100,300,11);
System(:,:,1,1)=1;
System(:,:,299,1)=3;
System(:,:,2:298,1)=2;
System(:,:,1,3)=1;
% System(25:75,25:75,40,1)=1;

 