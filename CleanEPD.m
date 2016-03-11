function [Pi] = CleanEPD( EPD )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
i=1;
j=1;

P(1,:)=EPD(:,1);
P(2,:)=EPD(:,3);
P(3,:)=EPD(:,4);
Pi(4,:)=EPD(1:1381,20);

while i<length(P(1,:))

  if P(1,i)==279+j && P(1,i)<=1660;
     Pi(1,j)=P(1,i);
     Pi(2,j)=P(2,i);
     Pi(3,j)=P(3,i);
     %Pi(4,j)=P(4,i);
     j=j+1;
  end
  
  i=i+1;
end





end

