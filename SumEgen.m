function [ total ] = SumEgen( System )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
S=size(System);
total=0;

  for i=1:S(1)

        for j=1:S(2)
             
                for k=1:S(3)
                    
                    if System(i,j,k,5)==1
                        total=total+System(i,j,k,2);
                    end
                    
                    
                end
                
                
        end
        
        
  end





end

