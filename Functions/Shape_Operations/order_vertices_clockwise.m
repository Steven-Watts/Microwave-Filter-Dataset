% Credit: Chapt GPT
function ordered_vertices = order_vertices_clockwise(vertices)
% Sort vertices in clockwise order using centroid as reference
centroid = mean(vertices);
angles = atan2(vertices(:,2) - centroid(2), vertices(:,1) - centroid(1));
[~, order] = sort(angles);
ordered_vertices = vertices(order,:);
end
