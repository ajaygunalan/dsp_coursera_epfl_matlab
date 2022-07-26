% $ d is the distance between two successive spirlas.
d = 10;
theta = linspace(0,360);
x = (theta/d).*cosd(theta);
y = (theta/d).*sind(theta);
plot(x,y);
grid on;