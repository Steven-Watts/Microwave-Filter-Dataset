% Credit: Chapt GPT
function binaryGrid = discretize_shape(vertices, n)
% Ensure vertices are in a clockwise order for correct polygon representation
vertices = order_vertices_clockwise(vertices);

% Generate n x n grid
x = linspace(0, 1, n);
y = linspace(0, 1, n);

% Initialize binary grid
binaryGrid = ones(n, n);

% Check each grid point if it lies inside the polygon
for i = 1:n
    for j = 1:n
        % Check if point (x(i), y(j)) is inside the polygon defined by vertices
        inside = inpolygon(x(i), y(j), vertices(:, 1), vertices(:, 2));
        if inside
            binaryGrid(j, i) = 0;  % Note the reversal of indices due to matrix indexing
        end
    end
end
end