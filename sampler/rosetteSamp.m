function [x y] = rosetteSamp(Image, t, a, k, nPoints,  bPlot)
    [height width] = size(Image);
    theta = linspace(0,360*t, nPoints);
    x = round(((width/2)+1)     + a*cos(k*theta).*cos(theta));
    y = round(((height/2)+1)    + a*cos(k*theta).*sin(theta));
    if (bPlot)
        imshow(Image);
        hold on;
        plot(x,y);
        axis([0 width 0 height]);
        grid on;
    end
end