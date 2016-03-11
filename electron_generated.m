function [ Pnn ] = lightman(  Pi )
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
  l=1000;
  
  
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


plot(Pnn(1,:));
hold on
plot(Pnn(5,:));


end

