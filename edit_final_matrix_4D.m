% Jackie Loven, jl2742, 5 February 2016

% 4D implementation.
% Editing the final matrix for the initial conditions:
% The first layer is conductor 1.
% The last layer is air, 0.
% The layer before this is conductor 2.

function originalMatrix = edit_final_matrix_4D(originalMatrix, bottomLayer, topLayer, underTopLayer)
    [xDim, yDim, zDim, aDim] = size(originalMatrix);
    originalMatrix(:,:,1,1) = bottomLayer;
    originalMatrix(:,:,zDim,1) = topLayer;
    originalMatrix(:,:,zDim - 1,1) = underTopLayer;
end

