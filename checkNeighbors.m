function b = checkNeighbors(i,j,k,v)
% Check neighbors of a(i,j,k) for the value v, return true if found
% a is an array with at least 3 dimensions

global a
b = false;
if i > 1 & a(i - 1,j,k,1) == v
    b = true;
    return;
end
if j > 1 & a(i,j - 1,k,1) == v
    b = true;
    return;
end
if k > 1 & a(i,j,k - 1,1) == v
    b = true;
    return;
end
if i < size(a,1) & a(i + 1,j,k,1) == v
    b = true;
    return;
end
if j < size(a,2) & a(i,j + 1,k,1) == v
    b = true;
    return;
end
if k < size(a,3) & a(i,j,k + 1,1) == v
    b = true;
    return;
end
end

