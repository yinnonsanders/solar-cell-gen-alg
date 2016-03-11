Size1 = size(S1);
for i=1:Size1(1)
    for j=1:Size1(2)
        z1(i,j) = sum(S1(i,j,:,2));
    end    
end

figure
[X0,Y0] = meshgrid(1:Size1(1),1:Size1(2));
% [X1,Y1] = meshgrid(1:.1:Size1(1),1:.1:Size1(2));
% Z1 = interp2(X0,Y0,z1,X1,Y1,'spline');
surf(X0,Y0,z1);
colormap hsv
shading interp
colorbar
title('Number of Electrons Excited in a Given "Pillar"')


% visualizeElectron(System(:,:,:,2))
% xlim([0,10])
% ylim([0,10])
% zlim([0,30])