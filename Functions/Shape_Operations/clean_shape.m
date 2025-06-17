function cleanedImg = clean_shape(Img)
    Img = double(Img);
    level = multithresh(Img);
    seg_I = imquantize(Img,level) -1;
    img = logical(~seg_I);
    
    [labeledImage, ~] = bwlabel(img);
    edges = unique(labeledImage);
    counts = accumarray(labeledImage(:)+1, 1);
    cleanedImg = img & ismember(labeledImage ,edges(counts > 3));
    cleanedImg = ~imfill(cleanedImg,"holes");
end