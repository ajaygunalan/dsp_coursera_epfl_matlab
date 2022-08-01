function [x y] = lissajousSamp(Image, A, B, delta, t, nPoints,  bPlot)
    [height width] = size(Image);
    T = linspace(0,t*pi, nPoints);
    a = 5;
    b = 6;
    x = round(((width/2)+1)+A*sin(a*T + delta));
    y = round(((height/2)+1)+B*sin(b*T));
    if (bPlot)
        imshow(Image);
        hold on;
        plot(x,y);
        axis([0 width 0 height]);
        grid on;
    end
end