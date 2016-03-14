function [efficiency] = fitnessFn(System)
tic;
%Takes a 4D matrix "System" and gives the efficiency.

%Creates Lightprop matrix
t00=cputime;
filename='EPVD1.xlsx';
EPD=xlsread(filename);
Lightprop=Lightqd(EPD);
close all

% Takes a matrix "System"(a) and "Lightprop" and finds excited electrons 
% in all indices close enough to a conductor; then, sums all those excited elections in matrix "System".
a=Egen1(System,Lightprop);
a=breadth_first1(a);
a=collection_zone_spherical(a);


total = 0;
for i=1:size(a,1)
    for j=1:size(a,2)
        for k=1:size(a,3)
            if a(i,j,k,5)==1
            total=total+a(i,j,k,2);
            end
        end
    end
end


% Converts total excited electrons to efficiency rating.
e=1.6*10^-16; %mah
A=10^-7*10^-7;%there was no fix for 5nm cube yet 
efficiency=(total/(size(a,1)*size(a,2)))*e/A;
toc
end