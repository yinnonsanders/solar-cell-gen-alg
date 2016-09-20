%  Jackie Loven, 17 March 2016

%  A = [x, y, z, extraParam, numberOfMatrices]
%  fittingFunction = [1 2 3 4 5];
%  tuner: integer 1..10
%  matrixList = {matrix1, matrix2, matrix3, matrix4, matrix5};

function newMatrixList = generate_crossovers(A, fittingFunction, tuner, matrixList)
    matrixCount = A(5);
    newMatrixList = cell(1, matrixCount);
    seeds = randi(11 - tuner);
    seedPercentage = round(80 / seeds);
    fittingFunctionIndices = 1:matrixCount;
    permutations = nchoosek(fittingFunctionIndices, 2);
    %  And you only need the first matrixCount number of permutations:
    %  neededPermutations = permutations(1:matrixCount, :);
    numberPermutes = size(permutations, 1);
    averageFit = zeros(numberPermutes, 1);

    for permutation = 1:numberPermutes
        fit1 = fittingFunction(permutations(permutation, 1));
        fit2 = fittingFunction(permutations(permutation, 2));
        averageFitForThisCross = (fit1 + fit2) / 2;
        averageFit(permutation, 1) = averageFitForThisCross;
    end
    
    permutationsForCrossing = cell(matrixCount, 1);
    %  Want to use the matrixCount number of highest average fits:
    for n = 1:matrixCount
        %  Highest average fit:
        [highestAverageFit, highestAverageFitIndex] = max(averageFit);
        permutationsForCrossing{n, 1} = permutations(highestAverageFitIndex, :);
        %  Now get rid of that fit so as not to double count:
        averageFit(highestAverageFitIndex) = [];
        permutations(highestAverageFitIndex, :) = [];
    end
   
    for cross = 1:matrixCount
        %  Can scale tuner if needed.
        matrix1 = matrixList{1, permutationsForCrossing{cross, 1}(1, 1)};
        matrix2 = matrixList{1, permutationsForCrossing{cross, 1}(1, 2)};
        newMatrix = generate_random_array(matrix2, matrix1, tuner, seeds, seedPercentage);
        newMatrixList{1, cross} = newMatrix;
    end
end

