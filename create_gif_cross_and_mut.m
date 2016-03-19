%  Jackie Loven, 17 March 2016

matrix1 = ones(100, 100, 300, 11);
matrix2 = ones(100, 100, 300) * 0;
matrix3 = ones(100, 100, 300) * 2;
%matrix4 = ones(10, 10, 10, 11) * 3;
%matrix5 = ones(10, 10, 10, 11) * 1;

%matrixList = {matrix1, matrix2, matrix3, matrix4, matrix5};
matrixList = {matrix1, matrix2, matrix3};

%  Assume matrix sizes are all the same.
x = size(matrixList{1, 1}, 1);
y = size(matrixList{1, 1}, 2);
z = size(matrixList{1, 1}, 3);
extraParamCount = size(matrixList{1, 1}, 4);
number = size(matrixList, 2);
A = [x, y, z, extraParamCount, number];

%  There will be an associated fitting function per matrix:
% Elapsed time for fitting function on 10x10x10 is approx. 55 seconds for
% each matrix.  
%  Tuner = 5, generationCount = 2:
[generationList, listOfMeans] = create_crossover_and_mutation_generation(A, 5, matrixList, 2);

fitFnValues = listOfMeans;
%  Goes up to generationCount:
x = 1:2;

close all
hold on
plot(x, fitFnValues)
set(gca,'fontsize', 14)
xlabel ('Generation')
ylabel ('Average Fitting Function Value')
title('Fitting Function Values Over Time')
hold off

ballsize = 8;
[xx, yy, zz] = meshgrid(1:10,1:10,1:10);

close all;
figure('position', [0, 500, 2100, 400])  % left, bottom, width, height
filename = 'test.gif';

for gen = 1:size(generationList,2)
    currentGen = generationList{1, gen};
    for mat = 1:A(5)
        currentMat = currentGen{1, mat}(:,:,:,1);
        subplot(1, A(5), mat)
        scatter3(xx(:),yy(:),zz(:), ballsize, currentMat(:), 'filled')
    end
    
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if gen == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
    %  Slow the gif down:
    pause(0.5)
end
    
   
