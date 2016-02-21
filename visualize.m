function visualize(a)
% display a in a scatter3 plot
% a must be a matrix with exactly 3 dimensions

% find positions of non zero elements of a
[x,y,z]=ind2sub(size(a),find(a > 0));

% generate different colors for each material
colors = zeros(size(x,1),3);
for i = 1:size(x,1)
    colors(i, a(x(i),y(i),z(i))) = 1;
end

% display results
scatter3(x,y,z,100,colors,'d','filled');

end

