function [System] = Fitfn(System)

%Finds efficiency of each particular point in a System

%Creates Lightprop matrix
t00=cputime;
filename='EPVD1.xlsx';
EPD=xlsread(filename);
Lightprop=Lightqd(EPD);

% Takes a matrix "System"(a) and rates it to the control matrix "control"
control = zeros(100,100,300,11);
control(:,:,1,1)=1;
control(:,:,299,1)=3;
control(:,:,2:298,1)=2;

%Runs Egen1 through both matrices

a=Egen1(System,Lightprop);
b=Egen1(control,Lightprop);

%Finds descrepencies in number of excited electrons from the control

i=1;
j=1;
k=1;

while i<=size(a,1)
    while j<=size(a,2)
        while k<=size(a,3)
            a(i,j,k,8)=a(i,j,k,2)-b(i,j,k,2);
            k=k+1;
        end
        j=j+1;
    end
    i=i+1;
end
% figure
% x=1:size(a,1);
% y=1:size(a,2);
% z=1:size(a,3);
% scatter3(x,y,z)
end
            
            
