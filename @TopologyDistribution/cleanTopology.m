function cleanedImg = cleanTopology(Imgs)
 
    Imgs = ~(Imgs > 0.5);
    cleanedImg = zeros(size(Imgs));

    for imageIdx = size(Imgs,4)
        img = squeeze(Imgs(:,:,1,imageIdx));
        [labeledImage, ~] = bwlabel(img);
        edges = unique(labeledImage);
        counts = accumarray(labeledImage(:)+1, 1);
        cleanedImg = img & ismember(labeledImage ,edges(counts > 3));
        cleanedImg = ~imfill(cleanedImg,"holes");
        cleanedImg(:,:,:,imageIdx) = cleanedImg;
    end
end