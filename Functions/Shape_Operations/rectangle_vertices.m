% Credit: Chapt GPT
function vertices = rectangle_vertices(center, length_, width, angle_deg)
% Convert angle from degrees to radians
angle_rad = deg2rad(angle_deg);

% Half-length and half-width
half_length = length_ / 2;
half_width = width / 2;

% Rotation matrix
R = [cos(angle_rad), -sin(angle_rad);
    sin(angle_rad), cos(angle_rad)];

% Vertices relative to the center
rel_vertices = [-half_length, -half_width;
    half_length, -half_width;
    half_length, half_width;
    -half_length, half_width];

% Rotate vertices and translate to the center
rotated_vertices = (R * rel_vertices')';
vertices = rotated_vertices + center;
end