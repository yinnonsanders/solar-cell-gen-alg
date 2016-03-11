function [ system ] = collect_e( system )

S = size(system);
total_e = 0;

for i = 1:S(1)
    disp('CE')
    disp(i)
    for j = 1:S(2)
        for k = 1:S(3)
            if(system(i,j,k,5)==1) %if it is a collection zone
               system(i,j,k,10) = system(i,j,k,4);
               total_e = total_e + system(i,j,k,4);
            end
        end
    end
end

total_e
end
