function [x y] = spiralSamp(Image, nSpirals, nPoints, dSpirals, bPlot)
    [height width] = size(Image);
    theta = linspace(0,360*nSpirals, nPoints*2);
    x = round(((width/2)+1) +(theta/dSpirals).*cosd(theta));
    y = round(((height/2)+1) +(theta/dSpirals).*sind(theta));
end