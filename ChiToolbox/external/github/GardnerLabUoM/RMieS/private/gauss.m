% Gaussian Function
%
% Usage: [g] = gauss(x,x0,a,c,graph);
%
% If you want a graph, enter 1 in the space of graph

function g = gauss(x,x0,a,c)






g = a * exp(  -  ((x-x0).^2) / (2*c^2));

end






