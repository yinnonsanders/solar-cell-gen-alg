function a = matrixMutate(m,n,t)
% Apply n mutations to matrix m
% a is an array with 4 dimensions
% v is a value from 1-10 that determines proximity of mutations
% 1 = random arrangement
% 10 = adjacent mutations

global a;
a = m;

% set floors and ceilings for mutation positions
floorx = 1;
ceilingx = size(a,1);
floory = 1;
ceilingy = size(a,2);
floorz = 2;
ceilingz = size(a,3) - 1;

% initialize ranges of mutation positions
minx = floorx;
maxx = ceilingx;
miny = floory;
maxy = ceilingy;
minz = floorz;
maxz = ceilingz;

% initialize counter
i = 0;

while i < n
    
    % generate new position
    x = randi([minx,maxx]);
    y = randi([miny,maxy]);
    z = randi([minz,maxz]);
    
    % attempt to mutate
    v = cellMutate(a,x,y,z);
    if v ~= -1
        a(x,y,z) = v;
        i = i + 1;
    end
    
    % initialize new ranges
    minx = uint32(x - (ceilingx / 2 - t * ceilingx / 20 + 1));
    minx = max([minx,floorx]);
    maxx = uint32(x + (ceilingx / 2 - t * ceilingx / 20 + 1));
    maxx = min([maxx,ceilingx]);
    miny = uint32(y - (ceilingy / 2 - t * ceilingy / 20 + 1));
    miny = max([miny,floory]);
    maxy = uint32(y + (ceilingy / 2 - t * ceilingy / 20 + 1));
    maxy = min([maxy,ceilingy]);
    minz = uint32(z - (ceilingz / 2 - t * ceilingz / 20 + 1));
    minz = max([minz,floorz]);
    maxz = uint32(z + (ceilingz / 2 - t * ceilingz / 20 + 1));
    maxz = min([maxz,ceilingz]);
    
end

end

