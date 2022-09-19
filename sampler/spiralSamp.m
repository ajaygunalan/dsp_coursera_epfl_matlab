function [x y] = spiralSamp(Image, nSpirals, nPoints, dSpirals, bPlot)
    [height width] = size(Image);
    theta = linspace(0,360*nSpirals, nPoints);
    x = round(((width/2)+1) +(theta/dSpirals).*cosd(theta));
    y = round(((height/2)+1) +(theta/dSpirals).*sind(theta));
    if (bPlot)
        axis image,  colormap(gray), axis off,
        imagesc(Image);
        hold on;
        plot(x,y);
        axis([0 width 0 height]);
        grid on;
    end
end