%  Jackie Loven, 23 February 2016

%  A = [x, y, z, extraParam, numberOfMatrices]
%  fittingFunction = [1 2 3 4 5];
%  tuner: integer 1..10
%  matrixList = [{matrix1} {matrix2} {matrix3} {matrix4} {matrix5}];

%  TODO: What do I get in place of a matrixList? 

function newMatrixList = generate_crossovers(A, fittingFunction, tuner, matrixList)
    newMatrixList = {};
    matrixCount = A(5);
    %  This can also be not random:
    for matrix = 1:matrixCount
        seeds = randi(11 - tuner);
        seedPercentage = round(80 / seeds);
        %  Tune based on the fitting function:
        randomIndex1 = randi(matrixCount);
        randomIndex2 = randi(matrixCount);
        randomMatrix1 = matrixList{1, randomIndex1};
        randomMatrix2 = matrixList{1, randomIndex2};
        randomMatrix1Fit = fittingFunction(randomIndex1);
        randomMatrix2Fit = fittingFunction(randomIndex2);
        betterFit = max(randomMatrix1Fit, randomMatrix2Fit);
        if (betterFit == randomMatrix1Fit)
            betterMatrix = randomMatrix1;
            worseMatrix = randomMatrix2;
        else
            betterMatrix = randomMatrix2;
            worseMatrix = randomMatrix1;
        end
        %  This can also be random.
        %  scaledTuner = randi(10);
        scaledTuner = betterFit/10 * 10;
        %seeds;
        newMatrix = generate_random_array(worseMatrix, betterMatrix, scaledTuner, seeds, seedPercentage);
        newMatrixList{1, matrix} = newMatrix;
    end
end