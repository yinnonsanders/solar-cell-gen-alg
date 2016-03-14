function b = checkNeighbors(m,i,j,k,v)
% Check neighbors of a(i,j,k) for the value v, return true if found
% a is an array with at least 3 dimensions

b = false;
if i > 1 & m(i - 1,j,k,1) == v
    b = true;
    return;
end
if j > 1 & m(i,j - 1,k,1) == v
    b = true;
    return;
end
if k > 1 & m(i,j,k - 1,1) == v
    b = true;
    return;
end
if i < size(m,1) & m(i + 1,j,k,1) == v
    b = true;
    return;
end
if j < size(m,2) & m(i,j + 1,k,1) == v
    b = true;
    return;
end
if k < size(m,3) & m(i,j,k + 1,1) == v
    b = true;
    return;
end
end

