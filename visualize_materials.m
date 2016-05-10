function visualize_materials(a)
% display a in a scatter3 plot
% a must be a matrix with exactly 3 dimensions

% find positions of non zero elements of a
[x,y,z]=ind2sub(size(a),find(a == 1));

% generate different colors for each material
% colors = zeros(size(x,1),3);
% for i = 1:size(x,1)
%     colors(i, a(x(i),y(i),z(i))) = 1;
% end

% display results
s = scatter3(x,y,z,200,'o','filled','MarkerEdgeColor',[.7,.7,.5],'MarkerFaceColor',[.6,.6,.4]);
set(gca,'fontsize', 14)
title('Bottom Conductor of Structure')
set(gcf,'color',[.7,.7,.7])
daspect([4,4,1])
grid off
axis off

%p = patch(isosurface(a,1));
%p.FaceColor = [.4,.4,.4];
%p.EdgeColor = 'none';
%daspect([3,3,1])
%view(3);
%axis off
%camlight
%lighting gouraud


end

