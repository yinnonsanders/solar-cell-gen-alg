function [Pnn] = Lightqd(EPD)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

   %what do we want to do?
   %take the "system", Take the "Light", figure out two thing first: what
   %is the incoming light properties second:where is the light going to
   %next?
   
   %First: incoming light is determined by 1.assume light beam width is
   %5nm, 2.each ray will be locked in a position?
   
   %meaning: light comes nitzav to the surface, then breaks in one
   %direction case closed.
   
   %coming light-->decay hits gold--> deflects--> keepdecay until hit upper
   %level
   
   % income always nitzav up to the first hit--> estimate Normal to local
   % surface--.direct light in that direction.
   
   
   %System defined by size, 30*30*60, means (:,:,1) is base layer.
   %light comes from (:,:,60)
   
   %In this document we have with respect to wavelength the number of photons
%Photons/(m^2 nm s)
%Pi contains wavelength with jumps of 1 nm on the second row, and in
%Photons/(cm^2 nm s) in the Third row

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
plot(Pnn(20,:));
hold on
plot(Pnn(30,:));
hold on
plot(Pnn(40,:));
hold on
plot(Pnn(50,:));
hold on
plot(Pnn(100,:));
hold on
plot(Pnn(150,:));
hold on
plot(Pnn(200,:));
hold on
plot(Pnn(250,:));
hold on
plot(Pnn(300,:));
hold on
plot(Pnn(400,:));
hold on
plot(Pnn(500,:));
hold on
plot(Pnn(600,:));
hold on
plot(Pnn(700,:));
hold on
plot(Pnn(800,:));
hold on
plot(Pnn(900,:));
hold on
plot(Pnn(1000,:));
hold on
plot(Pnn(1500,:));
hold on
plot(Pnn(1600,:));
hold on
plot(Pnn(1700,:));
hold on
plot(Pnn(1800,:));
hold on
plot(Pnn(1900,:));
hold on
plot(Pnn(2000,:));
hold on
plot(Pnn(4000,:));
title('Number of photons stored [5nm thick layer] for a given wavelength');
xlabel('Wavelength [nm]');
ylabel('Number of Photons');
grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%show me total number of electrons per 25nm square surface%

i=1;

while i<=4100
   S(i)=sum(Pnn(i,:)); 
   i=i+1;
end

Pnn(l+1,1:l)=S;



figure
plot(S);
title('Number of photons carried by wave packet vs Depth crossed ');
xlabel('Depth Crossed [nm]');
ylabel('Number of Photons');
grid



end

