inputMatrix = ones(10,10,10,11,5);
inputMatrix(:,:,:,1,1) = 1;
inputMatrix(:,:,:,1,2) = 0;
inputMatrix(:,:,:,1,3) = 1;
inputMatrix(:,:,:,1,4) = 2;
inputMatrix(:,:,:,1,5) = 3;
matrix2 = ones(10, 10, 10, 11) * 0;
matrix3 = ones(10, 10, 10, 11) * 2;
matrix4 = ones(10, 10, 10, 11) * 3;
matrix5 = ones(10, 10, 10, 11) * 1;

matrixList = {matrix1, matrix2, matrix3, matrix4, matrix5};

% Make sure the input matrices fits parameters.
for i = 1:generationSize
    inputMatrix(:,:,:,:,i) = edit_final_matrix_4D(inputMatrix(:,:,:,:,i),1,0,3);
end

%  Assume matrix sizes are all the same.
generationSize = size(inputMatrix, 2);
numberOfGenerations = 5;
outputMatrix = [size(inputMatrix), numberOfGenerations];
outputMatrix(:,:,:,:,:,1) = inputMatrix;

%  There will be an associated fitting function per matrix:
for generation = 1:numberOfGenerations
    for matrix = 1:generationSize
        fittingFunction(matrix) = fitnessFn(matrixList{1, matrix});
    end
    generatedMatrixList = generate_crossovers(A, fittingFunction, 5, matrixList);
end

for matrix = 1:generationSize
    %  Make sure the matrix fits parameters.
    edit_final_matrix_4D(matrixList{1, matrix}, 1, 0, 3)
    fittingFunction(matrix) = fitnessFn(matrixList{1, matrix});
end
generatedMatrixList = generate_crossovers(A, fittingFunction, 5, matrixList);

for matrix = 1:generationSize
    edit_final_matrix_4D(generatedMatrixList{1, matrix}, 1, 0, 3)
    fittingFunction1(matrix) = fitnessFn(generatedMatrixList{1, matrix});
end
generatedMatrixList2 = generate_crossovers(A, fittingFunction, 5, generatedMatrixList);

for matrix = 1:generationSize
    edit_final_matrix_4D(generatedMatrixList2{1, matrix}, 1, 0, 3)
    fittingFunction2(matrix) = fitnessFn(generatedMatrixList2{1, matrix});
end
generatedMatrixList3 = generate_crossovers(A, fittingFunction, 5, generatedMatrixList2);

for matrix = 1:generationSize
    edit_final_matrix_4D(generatedMatrixList3{1, matrix}, 1, 0, 3)
end

generationsList = {generatedMatrixList; generatedMatrixList2; generatedMatrixList3};

ballsize = 8;
[xx, yy, zz] = meshgrid(1:10,1:10,1:10);

close all;
figure('position', [0, 500, 2100, 400])  % left, bottom, width, height
filename = 'test.gif';

fittingFunctionAverage = mean(fittingFunction);
fittingFunctionAverage2 = mean(fittingFunction2);
fittingFunctionAverage3 = mean(fittingFunction3);
fitFnValues = [fittingFunctionAverage fittingFunctionAverage2 fittingFunctionAverage3];
x = [1 2 3];

close all
hold on
plot(x, fitFnValues,'k*')
set(gca,'fontsize', 14)
xlabel ('Generation')
ylabel ('Average Fitting Function Value')
title('Fitting Function Values Over Time')
hold off


for numberOfGenerations = 1:size(generationsList,1)
    for numberOfMembers = 1:generationSize
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