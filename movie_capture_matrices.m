%  Jackie Loven, 13 March 2016

matrix1 = ones(10, 10, 10, 11);
matrix2 = ones(10, 10, 10, 11) * 2;
matrix3 = ones(10, 10, 10, 11) * 3;
matrix4 = ones(10, 10, 10, 11) * 4;
matrix5 = ones(10, 10, 10, 11) * 5;

matrixList = {matrix1, matrix2, matrix3, matrix4, matrix5};

%  Assume matrix sizes are all the same.
x = size(matrixList{1, 1}, 1);
y = size(matrixList{1, 1}, 2);
z = size(matrixList{1, 1}, 3);
extraParamCount = size(matrixList{1, 1}, 4);
number = size(matrixList, 2);
A = [x, y, z, extraParamCount, number];

%  There will be an associated fitting function per matrix:
fittingFunction = [1 4 3 2 5];

generatedMatrixList = generate_crossovers(A, fittingFunction, 5, matrixList);

ballsize = 8;
[xx, yy, zz] = meshgrid(1:10,1:10,1:10);
matrixA = generatedMatrixList{1,1}(:,:,:,1);
matrixB = generatedMatrixList{1,2}(:,:,:,1);
matrixC = generatedMatrixList{1,3}(:,:,:,1);
matrixD = generatedMatrixList{1,4}(:,:,:,1);
matrixE = generatedMatrixList{1,5}(:,:,:,1);
matrixListNew = {matrixA, matrixB, matrixC, matrixD, matrixE};

axis tight manual
ax = gca;
ax.NextPlot = 'replaceChildren';

loops = 5;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    scatter3(xx(:),yy(:),zz(:), ballsize, matrixA(:), 'filled')
    drawnow
    F(j) = getframe(gcf);
end


% fig = figure;
% movie(fig,F,1)

