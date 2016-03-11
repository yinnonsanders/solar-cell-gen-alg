function hp = voxel(v0, dSize, cubeColor, cubeAlpha)
% function voxel(v0,dSize,cubeColor,alpha);
%   ====== Input
%   voxel(v0, dSize, cubeColor, cubeAlpha)
%   v0               xyz-cube-start; default [0 0 0]
%   dSize          xyz-cube-size 
%  cubeColor   cube color 
%   alpha         transparency alpha (1 for opaque, 0 for transparent)
%  Inna, 2014
%  Example: voxel([1 1 1],[1  2 3],'r',0.1)
%  Inspired by: %http://www.mathworks.com/matlabcentral/fileexchange/3280-voxel
 
if ~exist('cubeColor','var')
	cubeColor = 'b';
end
if ~exist('cubeAlpha','var')
    cubeAlpha = 1; % not transparent
end

cubeStr.vertices = [0 0 0; 0 1 0; 1 1 0; 1 0 0; ...
    0 0 1;  0 1 1; 1 1 1; 1 0 1];
cubeStr.faces = [1 2 3 4;  5 6 7 8;...
    1 5 6 2; 4 8 7 3; ...
    1 5 8 4; 2 6 7 3];

cubeStr.FaceAlpha  = cubeAlpha;
cubeStr.FaceColor  = cubeColor;

if exist('dSize','var')
    % scaling;
	cubeStr.vertices = ones(8,1)*dSize.*cubeStr.vertices;
end
if exist('v0','var')
    % shift;
	cubeStr.vertices = ones(8,1)*v0 + cubeStr.vertices;
end

hp = patch(cubeStr);
