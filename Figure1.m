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


figure
plot(x,y0,'r');
hold on
plot(x,y1)
grid on
xlabel('Thickness (nm)')
ylabel('JSC (mA/cm^{2})')
title('JSC Per Thickness of Solar Cell')
legend('Egen0','Egen1')

    