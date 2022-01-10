function h = compose12(f, g)
h = @composeFcn;
    function y = composeFcn(x)
        y = f(g(x));
    end
end