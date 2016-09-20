%  Jackie Loven, 17 March 2016

function [generationList, listOfMeans] = create_crossover_and_mutation_generation(A, tuner, matrixListIn, generationCount)

    matrixList = matrixListIn;
    matrixCount = size(matrixList, 2);
    matrixElementCount = A(1) * A(2) * A(3);
    fittingFunction = zeros(1, matrixCount);
    listOfMeans = zeros(1, generationCount);
    generationList = cell(1, generationCount);
   
    for gen = 1:generationCount
        mutationMatrixList = cell(1, matrixCount);
        for mat = 1:matrixCount
            %  Regulate all existing matrices in matrixList before crossing:
            matrixList{1, mat} = edit_final_matrix_4D(matrixList{1, mat}, 1, 0, 3);
            %  Find fitness of each matrix in current generation:
            fittingFunction(mat) = fitnessFn(matrixList{1, mat});
            %  TODO: ADD DIRECTED MUTATIONS, this is undirected mutations:
            mutationMatrixList{1, mat} =  edit_final_matrix_4D(matrixMutate(matrixList{1, mat}, 1/tuner * matrixElementCount, tuner), 1, 0, 3);
        end
        listOfMeans(1, gen) = mean(fittingFunction);
        crossoverMatrixList = generate_crossovers(A, fittingFunction, tuner, matrixList);
        %  Now pick half of these, here just the first half of each generation
        %  is taken (random) but it can be altered to account for fitting
        %  function:
        splittingNumber = round(matrixCount / 2); %  Accounts for odd number matrixCount
        listsSplitForGeneration = [crossoverMatrixList(1, 1:splittingNumber), mutationMatrixList(1,splittingNumber + 1:end)];
        generationList{1, gen} = listsSplitForGeneration
    end
end
