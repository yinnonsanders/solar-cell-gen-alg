%  Jackie Loven, 16 March 2016

%  A = [x, y, z, extraParam, numberOfMatrices]
%  fittingFunction = [1 2 3 4 5];
%  tuner: integer 1..10
%  matrixList = [{matrix1} {matrix2} {matrix3} {matrix4} {matrix5}];

function newMatrixList = generate_crossovers(A, fittingFunction, tuner, matrixList)
    matrixCount = A(5);
    newMatrixList = cell(1, matrixCount);
    %  This can also be not random:
    for matrix = 1:matrixCount
        seeds = randi(11 - tuner);
        seedPercentage = round(80 / seeds);
        fittingFunctionCopy = fittingFunction;
        [worstValue, minIndex] = min(fittingFunction);
        %  Remove the worst matrix from crossovers:
        fittingFunctionCopy(minIndex) = [];
        matrixList{1, minIndex} = 0;
        fittingFunctionIndices = 1:matrixCount - 1;
        %  You need all the matrices except the worst one for all needed
        %  permutations for getting the best matrices to cross to make a
        %  same-sized generation.
        bestPermutations = nchoosek(fittingFunctionIndices, 2);
        %  And you only need the first matrixCount number of permutations.
        neededPermutations = bestPermutations(1:size(bestPermutations,1) - 1, :);
        %  For each permutation, make a crossover:
        numberPermutes = size(neededPermutations, 1);
        for permutation = 1:numberPermutes
            %  Can scale tuner if needed:
            %  fitValue = fittingFunctionCopy(neededPermutations(permutation, 1));
            %  scaledTuner = fitValue/10 * 10;
            matrix1 = matrixList{1, neededPermutations(permutation, 1)};
            matrix2 = matrixList{1, neededPermutations(permutation, 2)};
            newMatrix = generate_random_array(matrix2, matrix1, tuner, seeds, seedPercentage);
            newMatrixList{1, matrix} = newMatrix;
        end
    end
end