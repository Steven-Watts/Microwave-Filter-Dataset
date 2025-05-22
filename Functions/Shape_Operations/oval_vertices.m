% Credit: Chapt GPT
function vertices = oval_vertices(center, width, height, angle_deg, m)
% Convert angle from degrees to radians (rotation angle)
angle_rad = deg2rad(angle_deg);

% Angles for generating vertices
theta = linspace(0, 2*pi, m+1);  % Equally spaced angles in radians
theta = theta(1:end-1);          % Remove the last point to avoid duplication

% Ellipse parameters
a = width / 2;    % Semi-major axis
b = height / 2;   % Semi-minor axis

% Parametric equations of the ellipse
x = a * cos(theta);
y = b * sin(theta);

% Rotation matrix
R = [cos(angle_rad), -sin(angle_rad);
    sin(angle_rad), cos(angle_rad)];

% Rotate vertices and translate to the center
rotated_vertices = R * [x; y];
rotated_vertices = rotated_vertices + center';

% Output vertices as m-by-2 matrix
vertices = rotated_vertices';
end