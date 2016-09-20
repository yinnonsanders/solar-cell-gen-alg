function [ System ] = Pillar_maker( System,Xd,Yd,h,D )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

 S=size(System);
 i=1;
 j=1;
 
 while i<=S(1)
     j=1;
     while j<=S(2)
         System(i,j,1:h,1)=1;
         j=j+Yd;
     end
     i=i+Xd;
 end


end

