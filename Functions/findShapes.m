% Credit: Chapt GPT
function shapes = findShapes(grid)
    % Ensure the input is a binary matrix
    assert(islogical(grid) || all(ismember(grid(:), [0, 1])), 'Input must be a binary matrix');
    
    % Find connected components
    CC = bwconncomp(grid,4);
    
    % Initialize the shapes array
    shapes = cell(1, CC.NumObjects);
    
    % Convert the linear indices to row and column indices
    for i = 1:CC.NumObjects
        [rows, cols] = ind2sub(size(grid), CC.PixelIdxList{i});
        shapes{i} = [rows, cols];
    end
end