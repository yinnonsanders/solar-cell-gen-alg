%Light properties%
%In this version the data will be directrly imported from NREL Document%
%W=J/S, E/photon=1240*e/lambda, W/E/photon=photon/sec
t00=cputime;
filename='EPVD1.xlsx';
EPD=xlsread(filename);

%create a database that tells us how light carrying photones changes with
%respect to distance traveled trough a specific material in our case QD

%testing the Jsc of different thicknesses of flat solar cells

%create a database that tells us how light carrying photones changes with
%respect to distance traveled trough a specific material in our case QD
Lightprop=Lightqd(EPD);
for i=2:1:2000
    J(i,:)=OfC(i,Lightprop);
    J0(i,:)=OfC0(i,Lightprop);
end

plot(J(:,1));
hold on
plot(J(:,2));
hold on
plot(J0(:,1));
hold on
plot(J0(:,2));
grid
xlabel('Thickness of solar device [nm]')
ylabel('J [ma/cm^2]')

