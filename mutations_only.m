generationSize = 1;

generationCount = 3;

matrixList = cell(1,generationSize);
for i = 1:generationSize
    matrix = zeros(100,100,300,11);
    matrix(:,:,1,1)=1;
    matrix(:,:,299,1)=3;
    matrix(:,:,2:298,1)=2;
    matrixList{1,i} = matrix;
end

%  Assume matrix sizes are all the same.
x = size(matrixList{1, 1}, 1);
y = size(matrixList{1, 1}, 2);
z = size(matrixList{1, 1}, 3);
extraParamCount = size(matrixList{1, 1}, 4);
A = [x, y, z, extraParamCount, generationSize];

generationList = cell(1, generationCount);

% Matrix to hold fitness values for each matrix
fitnessMatrix = [generationSize, generationCount];

gen = 1;
gen

for mat = 1:generationSize
    currentMatrix = matrixList{1,mat};
    % Calculate fitness
    fitnessMatrix(mat, 1) = fitnessFn(currentMatrix);
end

generationList{1,1} = matrixList;

for gen = 2:generationCount
    gen
    [generationList{1,gen},fitnessMatrix(:,gen)] = generate_mutations(A,fitnessMatrix(:,gen - 1),5,generationList{1,gen - 1});
end

figure('position', [0, 500, 3000, 1000])  % left, bottom, width, height
filename = 'output.gif';

% Put fitness values in vector so they can be plotted
i = 1;
fitnessVector = zeros(1,generationSize * generationCount);
fitnessGeneration = zeros(1,generationSize * generationCount);
for gen = 1:generationCount
    for mat = 1:generationSize
        fitnessVector(1,i) = fitnessMatrix(mat,gen);
        fitnessGeneration(1,i) = gen;
        i = i + 1;
    end
end

f = figure();
scatter(fitnessGeneration, fitnessVector)
set(gca,'fontsize', 14)
xlabel ('Generation')
ylabel ('Fitness Function Value')
title('Fitness Function Values Over Time')
saveas(f, 'mutations_only.png');
