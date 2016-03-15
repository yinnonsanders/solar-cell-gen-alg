% 5D matrix for all matrices in first generation
inputMatrix = ones(10,10,10,11,5);
% Generate some random matrices for generation 1
inputMatrix(:,:,:,1,1) = randi(3,10,10,10);
inputMatrix(:,:,:,1,2) = randi(3,10,10,10);
inputMatrix(:,:,:,1,3) = randi(3,10,10,10);
inputMatrix(:,:,:,1,4) = randi(3,10,10,10);
inputMatrix(:,:,:,1,5) = randi(3,10,10,10);

generationSize = size(inputMatrix, 5);
numberOfGenerations = 10; % Change this for more interesting results!

% Make sure the input matrices fits specifications.
for i = 1:generationSize
    inputMatrix(:,:,:,:,i) = edit_final_matrix_4D(inputMatrix(:,:,:,:,i),1,0,3);
end

% Create 6D matrix to contain all matrices in all generations
x = size(inputMatrix,1);
y = size(inputMatrix,2);
z = size(inputMatrix,3);
outputMatrix = zeros(x,y,z,11,generationSize,numberOfGenerations);
outputMatrix(:,:,:,:,:,1) = inputMatrix;

% Matrix to hold fitness values for each matrix
fitnessMatrix = [generationSize, numberOfGenerations];

for gen = 1:numberOfGenerations
    for mat = 1:generationSize
        currentMatrix = outputMatrix(:,:,:,:,mat,gen);
        % Calculate fitness
        fitnessMatrix(mat, gen) = fitnessFn(currentMatrix);
        if gen ~= numberOfGenerations
            % Did not yet reach the last generation
            % Make next generation
            outputMatrix(:,:,:,:,mat,gen+1) = matrixMutate(currentMatrix,20,1);
        end
    end
end

figure('position', [0, 500, 3000, 1000])  % left, bottom, width, height
filename = 'output.gif';

% Put fitness values in vector so they can be plotted
i = 1;
fitnessVector = zeros(1,generationSize * numberOfGenerations);
fitnessGeneration = zeros(1,generationSize * numberOfGenerations);
for gen = 1:numberOfGenerations
    for mat = 1:generationSize
        fitnessVector(1,i) = fitnessMatrix(mat,gen);
        fitnessGeneration(1,i) = gen;
        i = i + 1;
    end
end

for gen = 1:numberOfGenerations
    for mat = 1:generationSize
        currentMatrix = outputMatrix(:,:,:,:,mat,gen);
        subplot(2,generationSize,mat)
        toDraw = currentMatrix(:,:,:,1);
        visualize_materials(toDraw)
    end
    
    subplot(2,generationSize,[generationSize + 1,2 * generationSize])
    scatter(fitnessGeneration, fitnessVector)
    set(gca,'fontsize', 14)
    xlabel ('Generation')
    ylabel ('Fitness Function Value')
    title('Fitness Function Values Over Time')
    
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