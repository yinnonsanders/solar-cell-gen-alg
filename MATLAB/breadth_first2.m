function [System] = breadth_first2(System)

System(:,:,1,3)=1;
i=1;
j=1;
k=2;
    while i<=size(System,1)
        while j<=size(System,2)
            if System(i,j,k,1)==1
                System(i,j,k,3)=1;
            end
        end
    end
    
S = size(System);

visited = zeros(S(1),S(2),S(3));
%visited vector
%=0 : neither visited nor in the queue
%=1 : in queue but not visited
%=2 : visited

for x = 1:S(1)
    disp('BF')
    disp(x)
    for y = 1:S(2)
        p = 2;
        q = 1;
        %S(1)*S(2)*S(3)
        queue = zeros(S(1)*S(2)*S(3),3);
        queue(q,1) = x;
        queue(q,2) = y;
        queue(q,3) = 1;
        i = x;
        j = y;
        k = 3;
        queue(:,1);
        if system(i,j,k,1)==1
            while( queue(q,1)~=0 )
                %                disp([i j k])
                %                disp([queue(:,1) queue(:,2) queue(:,3)])
                %                    disp([queue(:,1) queue(:,2) queue(:,3)])
                %                    disp([i j k])
                
                size(queue);
                i = queue(q,1);
                j = queue(q,2);
                k = queue(q,3);
                visited(i,j,k)=1;
                System(i,j,k,3)=1;
                
                for m = -1:2:1
                    %%%%%%%%%%
                    %x direction
                    if ((i+m>0) && (i+m<=S(1)))
                        if visited(i+m,j,k)==0
                            if system(i+m,j,k,1)==1
                                queue(p,1) = i+m;
                                queue(p,2) = j;
                                queue(p,3) = k;
                                visited(i+m,j,k)=1;
                                p = p+1;
                            end
                        end
                    end
                    
                    %y direction
                    if ((j+m>0) && (j+m<=S(2)))
                        if visited(i,j+m,k)==0
                            if System(i,j+m,k,1)==1
                                queue(p,1) = i;
                                queue(p,2) = j+m;
                                queue(p,3) = k;
                                visited(i,j+m,k)=1;
                                p = p+1;
                            end
                        end
                    end
                    
                    %z direction
                    if ((k+m>0) && (k+m<=S(3)))
                        if visited(i,j,k+m)==0
                            if system(i,j,k+m,1)==1
                                %                                  disp([i j k m q]);
                                %                                 visited(i,j,k+m);
                                queue(p,1) = i;
                                queue(p,2) = j;
                                queue(p,3) = k+m;
                                visited(i,j,k+m)=1;
                                p = p+1;
                            end
                        end
                    end
                    %%%%%%%%%%
                end
                q = q + 1;
                %                    disp([queue(:,1) queue(:,2) queue(:,3)])
                %                    visited(i,j,k)
            end
        end
    end
end
end


        
            