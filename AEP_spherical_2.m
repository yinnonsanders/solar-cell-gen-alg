function [ system ] = AEP_spherical_2( system )


%
%using periodic boundary conditions
%


S = size(system);
%50 30 20
e_dist = [0.5 0.5 0.5 0.5];
%e_dist = [0.000595278 0.00221749 0.00483737 0.00833434 0.0125493 0.0172939 0.0223605 0.0275335 0.0326007 0.0373632 0.0416452 0.0453003 0.0482174 0.0503233 0.051583 0.0519982 0.0516039 0.0504637 0.0486633 0.0463047 0.0434997 0.0403631 0.0370082 0.0335411 0.0300578 0.0266414 0.0233603 0.0202684 0.0174045 0.0147938 0.0124492 0.010373 0.00855921 0.00699476 0.00566199 0.00454011 0.00360663 0.00283865 0.00221376 0.00171075 0.00131011 0.000994315];
%e_dist = [134.945, 504.821, 1109.02, 1929.61, 2942.47, 4118.08, 5422.67, 6819.38, 8269.54, 9734., 11174.4, 12554.2, 13840., 15003.2, 16018.1, 16865.8, 17532.1, 18008.7, 18292.7, 18386.3, 18296.5, 18034.3, 17614.3, 17053.7, 16371.7, 15588.6, 14725.3, 13802.5, 12840.2, 11857.3, 10870.8, 9896.06, 8946.32, 8032.65, 7163.92, 6346.91, 5586.42, 4885.4, 4245.16 ,3665.61];

%d = distance 
d_final = 300;
d_factor = 1;

surr_qd = zeros(d_final,1);
for d = 1:(d_final/d_factor)
    for m = -d*d_factor:d*d_factor
        for n = -d*d_factor:d*d_factor
            for l = -d*d_factor:d*d_factor
                if m*m + n*n + l*l <= d*d*d_factor*d_factor
                    if m*m + n*n + l*l > (d-1)*(d-1)*d_factor*d_factor
                        surr_qd(d) = surr_qd(d) + 1;
                    end
                end
            end
        end
    end
end

neigh_x=0;
neigh_y=0;
neigh_z=0;

neigh_test = 4;
for i = 1:S(1)
    disp('AEP')
    disp(i)
    for j = 1:S(2)
        for k = 1:S(3)
            if system(i,j,k,1)==0 && system(i,j,k,5)==0 %if the current voxel is a QD outside the collection zone
                %check for neighbors
                for d = 1:d_final/d_factor

                    
                    for m = -d*d_factor:d*d_factor
                        for n = -d*d_factor:d*d_factor
                            for l = -d*d_factor:d*d_factor
                                if m*m + n*n + l*l <= d*d_factor*d*d_factor
                                    if m*m + n*n + l*l > (d-1)*(d-1)*d_factor*d_factor
                                        if (k+l<=S(3))
                                            neigh_x = i+m;
                                            neigh_y = j+n;
                                            if i+m<1
                                                neigh_x = i+m+S(1);
                                            end
                                            
                                            if i+m>S(1)
                                               neigh_x = i+m-S(1);
                                            end
                                            
                                            if j+n<1
                                                neigh_y = j+n+S(2);
                                            end
                                            
                                            if j+n>S(2)
                                               neigh_y = j+n-S(2);
                                            end

%                                            neigh_x = mod(i+m+S(1),S(1));
%                                            neigh_y = mod(j+n+S(2),S(2));
                                            neigh_z = k+l;
                                            if (k+l<=1) %if it would diffuse to below 
                                                neigh_z = 1;
                                            end
                                            system(neigh_x,neigh_y,neigh_z,4) = system(neigh_x,neigh_y,neigh_z,4)+e_dist(d)*system(i,j,k,2)/(surr_qd(d));
                                        end 
                                    end 
                                end 
                            end 
                        end 
                    end  
                end
            else
                system(i,j,k,4) = system(i,j,k,4) + system(i,j,k,2);
            end
        end
    end
end