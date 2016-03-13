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
for matrix = 1:number
    fittingFunction(matrix) = fitnessFn(matrixList{1, matrix});
end
generatedMatrixList = generate_crossovers(A, fittingFunction, 5, matrixList);
for matrix = 1:number
    fittingFunction(matrix) = fitnessFn(generatedMatrixList{1, matrix});
end
generatedMatrixList2 = generate_crossovers(A, fittingFunction, 5, generatedMatrixList);
for matrix = 1:number
    fittingFunction(matrix) = fitnessFn(generatedMatrixList2{1, matrix});
end
generatedMatrixList3 = generate_crossovers(A, fittingFunction, 5, generatedMatrixList2);
generationsList = {generatedMatrixList; generatedMatrixList2; generatedMatrixList3};

ballsize = 8;
[xx, yy, zz] = meshgrid(1:10,1:10,1:10);

close all;
figure('position', [0, 500, 2100, 400])  % left, bottom, width, height
filename = 'test.gif';

for numberOfGenerations = 1:size(generationsList,1)
    for numberOfMembers = 1:number
        currentGen = generationsList{numberOfGenerations,1};
        current = currentGen{1,numberOfMembers};
        subplot(1,5,numberOfMembers)
        toDraw = current(:,:,:,1);
        scatter3(xx(:),yy(:),zz(:), ballsize, toDraw(:), 'filled')
    end
    
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if numberOfGenerations == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
    %  Slow the gif down:
    pause(0.5)
end