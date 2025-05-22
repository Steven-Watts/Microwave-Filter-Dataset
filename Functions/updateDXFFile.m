function updateDXFFile(fileName,shapes)

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
    vert = (shapes{k}.*0.5 - 8.25);

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
        fprintf(fileID,'%d\n',vert(iv,1));
        fprintf(fileID,'20\n');
        fprintf(fileID,'%d\n',vert(iv,2));
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