function [ system ] = collection_zone_spherical( system )
%d = distance
d = 150;
S = size(system);

system(:,:,1:d,5)=1;
% for i=1:S(1)
%     for j=1:S(2)
%         for k=d+1:S(3)
%             if system(i,j,k,3)==1
%                 if ((S(1)-i)*(S(1)-i)+(S(2)-j)*(S(2)-j)+(S(3)-k)*(S(3)-k))<= (150*150)
% j=1;
% k=d+1;



while i <= S(1)
    disp('CL')
    disp(i)
    j=1;
    while j <= S(2)
        k=d+1;
        while  k <= S(3)
            if system(i,j,k,3)==1 %if the current voxel is a connected conductor
                
                %check for neighbors
                for m = -d:d
                    if i+m>d
                        for n = -d:d
                            for l = -d:d
                                if m~=0 && n~=0 && l~=0 %if it is not the voxel analysed
                                    if ((i+m>0) && (i+m<=S(1)) && (j+n>0) && (j+n<=S(2)) && (k+l>0) && (k+l<=S(3)))%in the bounderies of the volume
                                        if system(i+m,j+n,k+l,1)==2 %if its a QD
                                            if system(i+m,j+n,k+l,5)==0; %not already marked
                                                
                                                if (m*m + n*n + l*l) <= d*d
                                                    system(i+m,j+n,k+l,5)=1;
                                                    
                                                end
                                                
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
            end
            k=k+1;
        end
        j=j+1;
    end
    i=i+1;
end



end
