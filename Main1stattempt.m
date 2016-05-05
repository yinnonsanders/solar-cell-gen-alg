% This is a new attempt%
clear all
clc

%Light properties%
%In this version the data will be directrly imported from NREL Document%
%W=J/S, E/photon=1240*e/lambda, W/E/photon=photon/sec
t00=cputime;
filename='EPVD1.xlsx';
EPD=xlsread(filename);

%create a database that tells us how light carrying photones changes with
%respect to distance traveled trough a specific material in our case QD
Lightprop=Lightqd(EPD);

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
hold on
grid
xlabel('Thickness of solar device [nm]')
ylabel('J [ma/cm^2]')

%tesing Jsc for pillar architectures%

for i=2:1:2000
    J(i,:)=OpC(i,Lightprop);
end



%define the system architeture
System = zeros(100,100,300,11);
System(:,:,1,1)=1;


System=Egen1(System,Lightprop);
System(500,500,1:300,1)=1;
S=size(System);

t00=cputime-t00;

%Propogate light
t0=cputime;
System0=Egen0(System,Lightprop); % 0 reflection
t0=cputime-t0;

t1=cputime;
System=Egen1(System,Lightprop); % 1 reflection 180 degrees
t1=cputime-t1;

%Defusion Model
Ld=80;
R=240;
QDmatrix=QDefussion(Ld,R); %quadratic defussion matrix

%*************************************************************************
%Create pillar array

Xd=300;
Yd=300;
H=100;
D=1;

System=Pillar_maker(System,Xd,Yd,H,D);
S=size(System);

%*************************************************************************
%1-Stores structure
%2-Stores generated electrons
%3-Stores the conectivity structure
%4-AEP
%5- Collection zone
%*************************************************************************
N1=SumEgen(System);
N=sum(System(1,1,:,2));
e=1.6*10^-16; %mah
A=10^-7*10^-7;%there was no fix for 5nm cube yet
A1=S(1)*S(2)*10^-14;
J_Test=N*e/A;
J_Test1=N1*e/A1;

%*************************************************************************
%Tryouts stores at 3
t2 = cputime;
System = breadth_first1(System);
t2 = cputime-t2;

t3 = cputime;
System = collection_zone_spherical(System);
t3 = cputime-t3;

%print_cell(system3);

t4 = cputime;
System = AEP_spherical_2(System);
t4 = cputime-t4;


t8=cputime;
System=QDefussion(Ld,R,System);
t8=cputime-t8;

t5 = cputime;
System = collect_e(System);
t5 = cputime-t5;

t6=cputime;

e=1.6*10^-16; %mah
A=10^-7*10^-7;%there was no fix for 5nm cube yet
J_collected=N*e/A;
J=J_collected;
t6=cputime-t6;


%*************************************************************************
St=System(:,:,:,1);
Aep=system(:,:,:,4);
Cz=System(:,:,:,5);
Lp=System(:,:,:,2);


[m n o]=size(St);
[x,y,z] = meshgrid(1:m,1:n,1:o);

figure (5)
scatter3(x(:),y(:),z(:),1,St(:),'filled')
%view(1, 50)

figure (6)
scatter3(x(:),y(:),z(:),1,Cz(:),'filled')

figure (3)
scatter3(x(:),y(:),z(:),1,Aep(:),'filled')

figure (4)
scatter3(x(:),y(:),z(:),1,Lp(:),'filled')
%**************************************************************************
i=2;

while i<2000
    
    %define the system%
    System = zeros(1,1,i,11);
    System(:,:,1,1)=1;
    
    %Electron generated per site embedded into matrix%
    %Egen1 is for 1 refelctions from flat surfaces for any structure%
    System1=Egen1(System,Lightprop);
    System0=Egen0(System,Lightprop);
    %Compute the short circut current for 1 cm^2 surface area
    N=sum(System1(1,1,:,2));
    e=1.6*10^-16; %mah
    A=10^-7*10^-7;%there was no fix for 5nm cube yet
    J_energized=N*e/A;
    N0=sum(System0(1,1,:,2));
    e=1.6*10^-16; %mah
    A=10^-7*10^-7;%there was no fix for 5nm cube yet
    J_energized0=N0*e/A;
    
    if i<300
        %Compute the short circut current for 1 cm^2 surface area
        N=sum(System1(1,1,1:i,2));
        e=1.6*10^-16; %mah
        A=10^-7*10^-7;%there was no fix for 5nm cube yet
        J_collected=N*e/A;
        N0=sum(System0(1,1,1:i,2));
        e=1.6*10^-16; %mah
        A=10^-7*10^-7;%there was no fix for 5nm cube yet
        J_collecte=N0*e/A;
    end
    
    
    if i>=300
        %Compute the short circut current for 1 cm^2 surface area
        N=sum(System1(1,1,1:300,2));
        e=1.6*10^-16; %mah
        A=10^-7*10^-7;%there was no fix for 5nm cube yet
        J_collected=N*e/A;
        N0=sum(System0(1,1,1:300,2));
        e=1.6*10^-16; %mah
        A=10^-7*10^-7;%there was no fix for 5nm cube yet
        J_collected0=N0*e/A;
    end
    
    
    J(1,i)=J_energized;
    J(2,i)=J_collected;
    J1(1,i)=J_energized0;
    J1(2,i)=J_collected0;
    i=i+1;
    
end

figure
plot(J(1,:));
hold on
plot(J1(1,:))
hold on
plot(J(2,:));
hold on
plot(J1(2,:))
grid
xlabel('Thickness of solar device [nm]')
ylabel('J [ma/cm^2]')
legend('1 reflection','no reflection','1 net collect','0 net collect')





%






%Define the Voxels Per Volume%
%Voxel size is 5 nm Means this is a 150*150*300nm volume size%
system = zeros(30,30,60,11);
S = size(system);



e_stored = zeros(S(3),1);

Po = Pi;

for k=1:S(3)
    for l=1:512
        Pn(l) = Po(l)*Pa(l);
        e_stored(k) = e_stored(k) + Po(l) - Pn(l);
        Po(l) = Pn(l);
    end
end




PO=sum(Pnn(1,:));

i=1;

while i<S(1)
    
    j=1;
    
    while j<S(2)
        
        %walk trough z untile you are out
        While
        
        system(i,j,k,2)=system(i,j,k,2)+PO-PN;
        
        
        
        
        j=j+1;
        
        
    end
    
    i=i+1;
    
end



load fluidtemp x y z temp                       % load data

xslice = [5 9.9];                               % define the cross sections to view
yslice = 3;
zslice = ([-3 0]);

slice(x, y, z, temp, xslice, yslice, zslice)    % display the slices
ylim([-3 3])
view(-34,24)

cb = colorbar;                                  % create and label the colorbar
cb.Label.String = 'Temperature, C';






