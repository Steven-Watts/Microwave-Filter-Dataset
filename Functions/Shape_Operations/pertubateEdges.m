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