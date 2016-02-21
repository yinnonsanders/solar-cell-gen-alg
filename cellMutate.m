function newValue = cellMutate(m,i,j,k)
% attempt to mutate cell in a at (i,j,k)
% return true if changed
% m is an array with at least 3 dimensions

newValue = -1;

% attempt to mutate to each other material
for v = 0:3
    if checkNeighbors(i,j,k,v) & m(i,j,k,1) ~= v
        newValue = v;
        return
    end
end

end

