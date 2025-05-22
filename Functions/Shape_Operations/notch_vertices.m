% Credit: Chapt GPT
function vertices = notch_vertices(corner, length_, width)

switch corner
    case 0
        vertices = [0 0;  length_, 0; 0, width];
    case 1
        vertices = [0 1; 0,1-length_; width, 1];
    case 2
        vertices = [1 0; 1, length_; 1-width, 0];
    case 3
        vertices = [1 1; 1-length_, 1; 1, 1-width];
end
end