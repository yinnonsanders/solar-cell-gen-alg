function [ ] = print_cell( system)

S = size(system);

for i = 1:S(1)
    for j = 1:S(2)
        for k = 1:S(3)
            if system(i,j,k,3)==1
                voxel([i j k], [1 1 1], [1 1 0.4], 0.8)
            end
             if system(i,j,k,5)==1
                voxel([i j k], [1 1 1], [0.4 1 0.4], 0.3)
            end
        end
    end
end
        

end

