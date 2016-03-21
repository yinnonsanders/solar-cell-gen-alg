function [ System ] = Egen1( System,Lightprop )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



S=size(System);


i=1;
mark=0;


while i<=S(1)
    
    
    j=1;
    
    while j<=S(2)
        
        
        k=S(3);
        mark=0;
        d=1;
        while mark~=2 && k<=S(3)
            
            if System(i,j,k,1)==1
                mark=mark+1;
                k=k+1;
            end
            
            if mark==0 && System(i,j,k,1)==2
                System(i,j,k,2)=System(i,j,k,2)+ Lightprop(4101,d)-Lightprop(4101,d+1);
                k=k-1;
                d=d+1;
            end
            if mark==0 && System(i,j,k,1)~=2 && System(i,j,k,1)~=1
                k=k-1;
            end
            if mark==1 && System(i,j,k,1)==2
                System(i,j,k,2)=System(i,j,k,2)+ Lightprop(4101,d)-Lightprop(4101,d+1);
                k=k+1;
                d=d+1;
            end
            if mark==1 && System(i,j,k,1)~=2 && System(i,j,k,1)~=1
                k=k+1;
            end
            if mark==0 && k==0
                break
            end
        end
        j=j+1;
    end
    i=i+1;
end





end

