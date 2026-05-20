classdef TopologyDistribution < handle

    properties(SetAccess=public)
        distribution
        vertices
        binaryGrid
        noise

    end

    methods
        function obj = TopologyDistribution(distribution,args)
            arguments
                distribution 
                args.noise = false; 
            end
            obj.distribution = distribution;
            obj.noise = args.noise;
        end

        function binaryGrid = sample(obj,args)
            arguments
                obj
                args.sampler = @rand; 
            end
            binaryGrid = (obj.distribution(args.sampler));

            if obj.noise
                binaryGrid = TopologyDistribution.pertubateEdges(binaryGrid);
            end
        end

    end

    methods(Static)
        function ordered_vertices = order_vertices_clockwise(vertices)
            % Sort vertices in clockwise order using centroid as reference
            centroid = mean(vertices);
            angles = atan2(vertices(:,2) - centroid(2), vertices(:,1) - centroid(1));
            [~, order] = sort(angles);
            ordered_vertices = vertices(order,:);
        end

        cleanedImg = cleanTopology(vertices)

        function binaryGrid = discretizeGrid(vertices,args)
            arguments
                vertices
                args.nx = 32;
                args.ny = 32;
            end
            % Ensure vertices are in a clockwise order for correct polygon representation
            vertices = TopologyDistribution.order_vertices_clockwise(vertices);

            % Generate n x n grid
            x = linspace(0, 1, args.nx);
            y = linspace(0, 1, args.ny);

            % Initialize binary grid
            binaryGrid = ones(args.nx, args.ny);

            % Check each grid point if it lies inside the polygon
            for ii = 1:args.nx
                for jj = 1:args.ny
                    % Check if point (x(i), y(j)) is inside the polygon defined by vertices
                    if inpolygon(x(ii), y(jj), vertices(:, 1), vertices(:, 2))
                        binaryGrid(jj, ii) = 0;  % Note the reversal of indices due to matrix indexing
                    end
                end
            end
        end

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

        function grid = pertubateEdges(grid)

            for ix = 1:size(grid,1)
                prevValue = grid(1,ix);
                for iy = 2:size(grid,1)
                    if prevValue ~= grid(ix,iy)
                        odds = rand(1);
                        if odds < 0.2
                            grid(ix,iy) = ~ grid(ix,iy);
                        elseif odds > 0.8
                            if iy > 1
                                grid(ix,iy) = ~ grid(ix,iy-1);
                            end
                        end

                    end
                    prevValue = grid(ix,iy);
                end
            end


            for iy = 1:size(grid,2)
                prevValue = grid(1,iy);
                for ix = 2:size(grid,1)

                    if prevValue ~= grid(ix,iy)
                        odds = rand(1);
                        if odds < 0.2
                            grid(ix,iy) = ~ grid(ix,iy);
                        elseif odds > 0.8
                            if ix > 1
                                grid(ix,iy) = ~ grid(ix-1,iy);
                            end
                        end
                    end

                    prevValue = grid(ix,iy);
                end
            end

        end

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
    end
end