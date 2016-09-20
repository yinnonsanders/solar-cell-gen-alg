%Creates plot of excited electrons at different points around the
S0 = Egen0(System,Lightprop);
A1 = S0(1,1,:,1);
A2 = S0(1,1,:,2);
V1=zeros(1,size(System,3));
for i=1:size(System,3);
    V1(i)=S0(1,1,i,2);
end

S1 = Egen1(System,Lightprop);
A3 = S1(1,1,:,1);
A4 = S1(1,1,:,2);
V2=zeros(1,size(System,3));
for i=1:size(System,3);
    V2(i)=S1(1,1,i,2);
end

figure
x = size(System,3):-1:1;
plot(x,V1,'r--');
hold on
plot(x,V2)
xlabel('Material Position (from top to bottom)')
ylabel('Number of Excited Electrons')
title('Number of Excited Electrons at a Given Depth')
legend('0 Reflections','1 Reflection')

