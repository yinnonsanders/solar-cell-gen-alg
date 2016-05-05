System=zeros(1,1,2000,11);
System(:,:,1,1)=1;
System(:,:,1999,1)=3;

filename='EPVD1.xlsx';
EPD=xlsread(filename);
Lightprop=Lightqd(EPD);
close all

x=1:size(System,3)-2;
y0=zeros(1,size(System,3)-2);
y1=zeros(1,size(System,3)-2);
A=Egen0(System,Lightprop);
B=Egen1(System,Lightprop);
total0=0;
total1=0;
for i=1:size(System,3)
    total0=total0+A(1,1,i,2);
    total1=total1+B(1,1,i,2);
end
e=1.6*10^-16;
Area=10^-7*10^-7;
total0=total0*(e/Area);
total1=total1*(e/Area);
y0(1)=total0;
y1(1)=total1;
System(:,:,:,2)=0;

for i=2:size(System,3)-2
    disp(i)
    System(1,1,i,1)=2;
    A=Egen0(System,Lightprop);
    B=Egen1(System,Lightprop);
    total0=0;
    total1=0;
    for j=1:size(System,3)
        total0=total0+A(1,1,j,2);
        total1=total1+B(1,1,j,2);
    end
    total0=total0*(e/Area);
    total1=total1*(e/Area);
    y0(i)=total0;
    y1(i)=total1;
    System(:,:,:,2)=0;
end

Pi=CleanEPD(EPD);
%this defines the search area
d=1;
%The effect for a 5nm voxel%
%photons/(cm^2 s nm) or Photons/(m^2 nm s)
%dx = 2.7
%multiply to 25*10^(-14)*2.7 for 5nm voxels
%ASK BEN.T?

Pi(2,:) = Pi(2,:)*(d^2)*10^-18;
Pi(3,:) = Pi(3,:)*(d^2)*10^-14;
   
   
   
   %unit jumps you are looking for
   d=1;
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %set data for d nm jumps%
   
   i=1;
   j=1;
 %creates a vector of multipliers for each wave length change%  
 while i<=length(Pi(4,:))
     Pa(j) = exp(-1*Pi(4,i));
     i=i+d;
     j=j+1;
 end
  
   i=1;
   j=1;
 %creates the light wave vector for the cm version%  
 while i<=length(Pi(3,:))
     Pi2(j) = Pi(3,i);
     i=i+d;
     j=j+1;
 end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Create Data base for decay with respect to the number of passage you are
  %in (how many voxels have i passed so far)
  
  Pnn(1,:)=Pi2;
  j=2;
  %l is the max distance light will travel trough matter%
  l=4100;
  
  
  while j<=l
  
  i=1;
  
  while i<=length(Pi2)
         Pn(i)=Pi2(i)*Pa(i);
         i=i+1;
  end
   
 
  Pi2=Pn;
  Pnn(j,:)=Pn;
  j=j+1;
   
  end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%now we want to use the data for a given system%
%start at the top cell 60, and walk on I,J to cover all enternce points

%% Show me how light carrying decline for each wave length with respect to distance traveled%%
figure
plot(Pnn(1,:));
hold on
plot(Pnn(10,:));
hold on
% plot(Pnn(20,:));
% hold on
% plot(Pnn(30,:));
% hold on
% plot(Pnn(40,:));
% hold on
plot(Pnn(50,:));
hold on
plot(Pnn(100,:));
hold on
% plot(Pnn(150,:));
% hold on
% plot(Pnn(200,:));
% hold on
plot(Pnn(250,:));
hold on
% plot(Pnn(300,:));
% hold on
% plot(Pnn(400,:));
% hold on
plot(Pnn(500,:));
hold on
% plot(Pnn(600,:));
% hold on
% plot(Pnn(700,:));
% hold on
% plot(Pnn(800,:));
% hold on
% plot(Pnn(900,:));
% hold on
plot(Pnn(1000,:));
 hold on
plot(Pnn(1500,:));
hold on
% plot(Pnn(1600,:));
% hold on
% plot(Pnn(1700,:));
% hold on
% plot(Pnn(1800,:));
% hold on
% plot(Pnn(1900,:));
% hold on
plot(Pnn(2000,:));
hold on
plot(Pnn(4000,:));
title('Number of photons stored [1nm thick layer] for a given wavelength');
xlabel('Wavelength of Light [nm]');
ylabel('Number of Photons');
legend('1 nm Depth', '10 nm Depth', '50 nm Depth', '100 nm Depth', '250 nm Depth', '500 nm Depth', '1000 nm Depth', '1500 nm Depth', '2000 nm Depth', '4000 nm depth')
grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%show me total number of electrons per 25nm square surface%

i=1;

while i<=4100
   S(i)=sum(Pnn(i,:)); 
   i=i+1;
end

Pnn(l+1,1:l)=S;

S=S*e/Area;

A0=zeros(1,size(y0,2));
for i=1:size(A0,2)
    if S(i)>y0(i)
        A0(i)=y0(i);
    elseif S(i)<y0(i)
        A0(i)=S(i);
    else
        A0(i)=y0(i);
    end
end

A1=zeros(1,size(y1,2));
for i=1:size(A1,2)
    if S(i)>y1(i)
        A1(i)=y1(i);
    elseif S(i)<y1(i)
        A1(i)=S(i);
    else
        A1(i)=y1(i);
    end
end
        
figure
plot(x,A0,'r');
hold on
plot(x,A1)
grid on
xlabel('Thickness (nm)')
ylabel('JSC (mA/cm^{2})')
title('JSC Per Thickness of Solar Cell')
legend('Egen0','Egen1')
