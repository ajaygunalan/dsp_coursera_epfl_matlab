%Data  
x = ones(1,12);
y = [1 1 2 3 3 3 4 5 6 2 2 2];
%Engine
[uxy, jnk, idx] = unique([x.',y.'],'rows');
szscale = histc(idx,unique(idx));
%Plot Scale of 25 and stars
scatter(uxy(:,1),uxy(:,2),'p','sizedata',szscale*25)