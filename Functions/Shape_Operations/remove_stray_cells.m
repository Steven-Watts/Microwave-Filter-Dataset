function cleanedGrid = remove_stray_cells(grid)
% Input:
%   grid: n by n binary matrix
% Output:
%   cleanedGrid: n by n binary matrix with stray cells removed

% Get the size of the grid
n = size(grid, 1);

% Initialize the cleaned grid as a copy of the input grid
cleanedGrid = grid;

% Iterate through each cell in the grid
for i = 1:n
    for j = 1:n
        % Check if the cell is a stray cell

        % Check its four neighbors (up, down, left, right)
        if i > 1 && grid(i-1,j) == grid(i,j) % Check above
            continue; % Valid neighbor found, move to next cell
        elseif i < n && grid(i+1,j) == grid(i,j) % Check below
            continue; % Valid neighbor found, move to next cell
        elseif j > 1 && grid(i,j-1) == grid(i,j) % Check left
            continue; % Valid neighbor found, move to next cell
        elseif j < n && grid(i,j+1) == grid(i,j) % Check right
            continue; % Valid neighbor found, move to next cell
        else
            % If none of the neighbors are '1', then it's a stray cell
            cleanedGrid(i,j) = ~cleanedGrid(i,j); % Set the cell to '0' (remove it)
        end
    end
end
end