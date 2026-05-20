classdef CSTInterface

    properties
        CST
        CST_fileName
    end

    methods
        function obj = CSTInterface(fileName)

            obj.CST = TCSTInterface();
            obj.CST_fileName = fileName;

            % Open specified .cst file or activate it if it is already open:
            obj.CST.OpenProject(fileName);
            Solver = obj.CST.Project.invoke('Solver');
            obj.CST.Project.invoke('RunScript',"DeleteResults.mcr");
            Solver.invoke('FrequencyRange','1','10');

        end

        function solution = solveCST(obj)
            obj.CST.Solve();
            [solution.S, solution.Freq, solution.Zref, solution.Info] = obj.CST.GetSParams();
            solution.S = squeeze(solution.S(:,:,:,1));
            solution.Zref = squeeze(solution.Zref(:,:,:,1));
        end

        function success = deleteResults(obj)
            try
                obj.CST.Project.invoke('RunScript',"DeleteResults.mcr");
                success = true;
            catch
                success = false;
            end
        end

        function success = updateCSTGrid(obj, topology)
            n = size(topology,1);
            try
                if n > 32
                    shapes = bwboundaries(~(topology));
                else
                    shapes = bwboundaries(~(topology),TraceStyle="pixeledge");
                end
                if isempty(shapes)
                    error('No shapes Detected to update CST GRID')
                end
                CSTInterface.updateDXFFile([fileparts(obj.CST_fileName) '\microwaveFilter\Model\3D\grid_1.dxf'],shapes,n);
                obj.CST.Project.invoke('RunScript',"updateGrid.mcs");
                success = true;
            catch
                success = false;
            end
        end

        function success = closeCST(obj)
            try
                obj.CST.CloseProject();
                success = true;
            catch
                success = false;
            end
        end
    end

    methods(Static)

        function updateDXFFile(fileName,shapes,n)

            fileID = fopen(fileName,'w');

            fprintf(fileID,'0\n');
            fprintf(fileID,'SECTION\n');
            fprintf(fileID,'2\n');
            fprintf(fileID,'HEADER\n');
            fprintf(fileID,'9\n');
            fprintf(fileID,'$ACADVER\n');
            fprintf(fileID,'1\n');
            fprintf(fileID,'AC1009\n');
            fprintf(fileID,'0\n');
            fprintf(fileID,'ENDSEC\n');
            fprintf(fileID,'0\n');
            fprintf(fileID,'SECTION\n');
            fprintf(fileID,'2\n');
            fprintf(fileID,'ENTITIES\n');
            fprintf(fileID,'0\n');

            for k = 1:length(shapes)
                vert = (shapes{k}.*(16/n) - 8.25);

                fprintf(fileID,'POLYLINE\n');
                fprintf(fileID,'8\n');
                fprintf(fileID,'SUBSTRATE\n');
                fprintf(fileID,'66\n');
                fprintf(fileID,'1\n');
                fprintf(fileID,'39\n');
                fprintf(fileID,'0\n');
                fprintf(fileID,'10\n');
                fprintf(fileID,'0.000000\n');
                fprintf(fileID,'20\n');
                fprintf(fileID,'0.000000\n');
                fprintf(fileID,'30\n');
                fprintf(fileID,'0.000000\n');
                fprintf(fileID,'70\n');
                fprintf(fileID,'1\n');
                fprintf(fileID,'0\n');

                for iv = 1:length(vert)

                    fprintf(fileID,'VERTEX\n');
                    fprintf(fileID,'8\n');
                    fprintf(fileID,'SUBSTRATE\n');
                    fprintf(fileID,'39\n');
                    fprintf(fileID,'0\n');
                    fprintf(fileID,'10\n');
                    fprintf(fileID,'%f\n',vert(iv,1));
                    fprintf(fileID,'20\n');
                    fprintf(fileID,'%f\n',vert(iv,2));
                    fprintf(fileID,'30\n');
                    fprintf(fileID,'0\n');
                    fprintf(fileID,'70\n');
                    fprintf(fileID,'0\n');
                    fprintf(fileID,'42\n');
                    fprintf(fileID,'0\n');
                    fprintf(fileID,'0\n');

                end
                fprintf(fileID,'SEQEND\n');
                fprintf(fileID,'8\n');
                fprintf(fileID,'SUBSTRATE\n');
                fprintf(fileID,'0\n');
            end

            fprintf(fileID,'ENDSEC\n');
            fprintf(fileID,'0\n');
            fprintf(fileID,'EOF\n');

            fclose(fileID);
        end
    end

end