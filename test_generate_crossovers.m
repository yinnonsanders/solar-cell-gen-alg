%  Jackie Loven, 23 February 2016

%  For example, make 5 random matrices of size 10x10x10 given this input to simulate getting 5 such matrices.
matrix1 = ones(10, 10, 10, 11);
matrix2 = ones(10, 10, 10, 11) * 2;
matrix3 = ones(10, 10, 10, 11) * 3;
matrix4 = ones(10, 10, 10, 11) * 4;
matrix5 = ones(10, 10, 10, 11) * 5;

%matrixList = [{matrix1}, {matrix2}, {matrix3}, {matrix4}, {matrix5}];
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

%  The function I write looks like
%  func(A, fittingFactor, tuner)
%  Runtime is 0.014694 seconds.
%tic;
generatedMatrixList = generate_crossovers(A, fittingFunction, 5, matrixList);
%toc
ballsize = 8;
[xx, yy, zz] = meshgrid(1:10,1:10,1:10);
matrixA = generatedMatrixList{1,1};
matrixB = generatedMatrixList{1,2};
matrixC = generatedMatrixList{1,3};
matrixD = generatedMatrixList{1,4};
matrixE = generatedMatrixList{1,5};

%  Runtime is 0.008380 seconds.
%tic;
generatedMatrixList2 = generate_crossovers(A, fittingFunction, 5, generatedMatrixList);
%toc
matrixA1 = generatedMatrixList2{1,1};
matrixB1 = generatedMatrixList2{1,2};
matrixC1 = generatedMatrixList2{1,3};
matrixD1 = generatedMatrixList2{1,4};
matrixE1 = generatedMatrixList2{1,5};

%  Runtime is 0.069995 seconds.
%tic;
generatedMatrixList3 = generate_crossovers(A, fittingFunction, 10, generatedMatrixList2);
%toc
matrixA2 = generatedMatrixList3{1,1};
matrixB2 = generatedMatrixList3{1,2};
matrixC2 = generatedMatrixList3{1,3};
matrixD2 = generatedMatrixList3{1,4};
matrixE2 = generatedMatrixList3{1,5};

%  To try the runtime of larger matrices:
matrix1a = ones(100, 100, 100, 11);
matrix2a = ones(100, 100, 100, 11) * 2;
matrix3a = ones(100, 100, 100, 11) * 3;
matrix4a = ones(100, 100, 100, 11) * 4;
matrix5a = ones(100, 100, 100, 11) * 5;
matrixAList = {matrix1a, matrix2a, matrix3a, matrix4a, matrix5a};
x = size(matrixAList{1, 1}, 1);
y = size(matrixAList{1, 1}, 2);
z = size(matrixAList{1, 1}, 3);
extraParamCount = size(matrixAList{1, 1}, 4);
number = size(matrixAList, 2);
A = [x, y, z, extraParamCount, number];
fittingFunction = [4 8 2 1 3];
%  Runtime is maximum 0.104084 seconds. Can be 0.004861 seconds.
tic;
generatedMatrixAList = generate_crossovers(A, fittingFunction, 5, matrixList);
toc

%  Check that the 4D implementation is changing the correct extraParam parameter (the first one  = material)
%disp(matrixE1(:, :, 7, 1))
%disp(matrixE2(:, :, 7, 1))
%  Check that it isn't changing anything else:
%disp(matrixE1(:, :, 7, 2))