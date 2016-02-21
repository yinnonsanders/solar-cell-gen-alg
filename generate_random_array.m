% Jackie Loven, 19 February 2016

%  Tuner goes from 1 to 10. 10 is fewer random replacements and more correlated.
%  1 is more random replacements and less correlated.
%  seeds is EITHER a matrix, n * 3, in which you can input n number of 3D coordinates,
%  OR a number of seeds (0 is permitted) for this function to randomly generate seeds itself.
%  seedPercentage is the percentage of replacements that will be alotted to be nearby each seed (0 is permitted).
%  seeds * seedPercentage must be less than or equal to 100
%  The remainder of replacements not allotted to seeds will be randomly placed.

function originalMatrix = generate_random_array(originalMatrix, newMatrix, tuner, seeds, seedPercentage)
    
    %%  UNSEEDED REPLACEMENTS:
    
    originalXMax = size(originalMatrix, 1);
    originalYMax = size(originalMatrix, 2);
    originalZMax = size(originalMatrix, 3);

    maxReplacementCount = originalXMax * originalYMax * originalZMax;
    %  If tuner is large, replacementFraction must be small:
    replacementFraction = 1 - (tuner/11); %  TODO: random for now, should be tunable.
    replacementCount = randi(round(maxReplacementCount * replacementFraction));
    
    if (size(seeds) == [1, 1]) %  Seeds have not been provided.
        assert((seeds * seedPercentage <= 100), 'Choose fewer seeds or a lower percentage of changes alotted per seed.');
        if (seeds ~= 0) %  Random seeds will be created.
            correlatedReplacementCount = ((seeds * seedPercentage) / 100) * replacementCount;
            seedXCoordinateList = randi(originalXMax, [seeds, 1]);
            seedYCoordinateList = randi(originalYMax, [seeds, 1]);
            seedZCoordinateList = randi(originalZMax, [seeds, 1]);
            seeds = horzcat(seedXCoordinateList, seedYCoordinateList, seedZCoordinateList);
            seedCount = size(seeds, 1);
        else %  No seeds shall be created.
            correlatedReplacementCount = 0;
            seedCount = 0;
        end
    else %  Seeds have been provided.
        seedCount = size(seeds, 1);
        assert((seedCount * seedPercentage <= 100), 'Choose fewer seeds or a lower percentage of changes alotted per seed.');
        correlatedReplacementCount = ((seedCount * seedPercentage) / 100) * replacementCount;
    end
    
    uncorrelatedReplacementCount = round(replacementCount - correlatedReplacementCount);
    uncorrelatedXCoordinateList = randi(originalXMax, [uncorrelatedReplacementCount, 1]);
    uncorrelatedYCoordinateList = randi(originalYMax, [uncorrelatedReplacementCount, 1]);
    uncorrelatedZCoordinateList = randi(originalZMax, [uncorrelatedReplacementCount, 1]);
    uncorrelatedCoordinateMatrix = horzcat(uncorrelatedXCoordinateList, uncorrelatedYCoordinateList, uncorrelatedZCoordinateList);
    
    for uncorrelatedElement = 1:size(uncorrelatedCoordinateMatrix, 1)
        x = uncorrelatedCoordinateMatrix(uncorrelatedElement, 1);
        y = uncorrelatedCoordinateMatrix(uncorrelatedElement, 2);
        z = uncorrelatedCoordinateMatrix(uncorrelatedElement, 3);
        if (originalMatrix(x, y, z) ~= newMatrix(x, y, z)) 
            originalMatrix(x, y, z) = newMatrix(x, y, z);
        end
    end

    %  SEEDED REPLACEMENTS:
    
    if (seedCount ~= 0)
        for seed = 1:seedCount
            %  Scalar determines how closely tied the seeds are.
            scalar = 3;
            seedXMinBound = seeds(seed, 1) - (replacementFraction * originalXMax /scalar);
            seedXMaxBound = seeds(seed, 1) + (replacementFraction * originalXMax /scalar);
            seedYMinBound = seeds(seed, 2) - (replacementFraction * originalYMax /scalar);
            seedYMaxBound = seeds(seed, 2) + (replacementFraction * originalYMax /scalar);
            seedZMinBound = seeds(seed, 3) - (replacementFraction * originalZMax /scalar);
            seedZMaxBound = seeds(seed, 3) + (replacementFraction * originalZMax /scalar);
            
            seedXMinBoundList(seed, 1) = seedXMinBound;
            seedXMaxBoundList(seed, 1) = seedXMaxBound;
            seedYMinBoundList(seed, 1) = seedYMinBound;
            seedYMaxBoundList(seed, 1) = seedYMaxBound;
            seedZMinBoundList(seed, 1) = seedZMinBound;
            seedZMaxBoundList(seed, 1) = seedZMaxBound;
        end
    
        %  Make sure they're in the matrix:
        %  min() brings up to a level -> 1
        %  max() brings down to a level -> originalMax
        seedXMinBoundList = round(max(seedXMinBoundList, 1));
        seedXMaxBoundList = round(min(seedXMaxBoundList, originalXMax));
        seedYMinBoundList = round(max(seedYMinBoundList, 1));
        seedYMaxBoundList = round(min(seedYMaxBoundList, originalYMax));
        seedZMinBoundList = round(max(seedZMinBoundList, 1));
        seedZMaxBoundList = round(min(seedZMaxBoundList, originalZMax));
        correlatedCoordinateRangesMatrix = horzcat(seedXMinBoundList, seedXMaxBoundList, seedYMinBoundList, seedYMaxBoundList, seedZMinBoundList, seedZMaxBoundList);
        
        correlatedCoordinateMatrix = [0, 0, 0]; %  Make one matrix to store correlated coordinates for each seed.
        replacementsPerSeed = round(correlatedReplacementCount / seedCount);
        for seed = 1:seedCount
                seedCorrelatedXCoordinateList = randi([correlatedCoordinateRangesMatrix(seed, 1), correlatedCoordinateRangesMatrix(seed, 2)], [replacementsPerSeed, 1]);
                seedCorrelatedYCoordinateList = randi([correlatedCoordinateRangesMatrix(seed, 3), correlatedCoordinateRangesMatrix(seed, 4)], [replacementsPerSeed, 1]);
                seedCorrelatedZCoordinateList = randi([correlatedCoordinateRangesMatrix(seed, 5), correlatedCoordinateRangesMatrix(seed, 6)], [replacementsPerSeed, 1]);
                seedCorrelatedCoordinateMatrix = horzcat(seedCorrelatedXCoordinateList, seedCorrelatedYCoordinateList, seedCorrelatedZCoordinateList);
                correlatedCoordinateMatrix = vertcat(correlatedCoordinateMatrix, seedCorrelatedCoordinateMatrix);
        end
        correlatedCoordinateMatrix(1,:) = []; %  Remove that first row of zeros.
        
        for correlatedElement = 1:size(correlatedCoordinateMatrix, 1)
            x = correlatedCoordinateMatrix(correlatedElement, 1);
            y = correlatedCoordinateMatrix(correlatedElement, 2);
            z = correlatedCoordinateMatrix(correlatedElement, 3);
            if (originalMatrix(x, y, z) ~= newMatrix(x, y, z)) 
                originalMatrix(x, y, z) = newMatrix(x, y, z);
            end
        end
        
    end    
end