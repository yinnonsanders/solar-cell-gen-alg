function [newMatrixList, newFitnessFunction] = generate_mutations(A, fitnessFunction, tuner, matrixList)
% Generates a mutated generation with half the number of individuals rounded
% down.
% tuner is an integer between 1 and 10 determining proximity of mutations
% A = [x, y, z, extraParam, numberOfMatrices]
% previousGeneration is a list of 4D matrices with A(5) members
% fitnessFunction is a vector with A(5) members

newMatrixList = cell(1, A(5));
newFitnessFunction = zeros(1,A(5));

% choose matrices to mutate
matrixIndices = randperm(A(5), floor(A(5) / 2 ));

newMat = 1;

for mat = 1:A(5)
    mutatedMatrix = matrixMutate(matrixList{1, mat}, A(1), tuner);
    mutatedFitnessFunction = fitnessFn(mutatedMatrix);
    if mutatedFitnessFunction >= fitnessFunction(mat)
        % mutated matrix is better
        newMatrixList{1, newMat} = mutatedMatrix;
        newFitnessFunction(newMat) = mutatedFitnessFunction;
    else
        % mutated matrix is worse
        newMatrixList{1, newMat} = matrixList{1, mat};
        newFitnessFunction(newMat) = fitnessFunction(mat);
    end
    newMat = newMat + 1;
end
    
end
