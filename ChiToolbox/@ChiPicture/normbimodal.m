function obj = normbimodal(varargin)

% function normbimodal
% 
% A scores matrix contains positive and negative values that have different
% maxima (minima). Here we normalise each principal component separately
% such that its positive scores are normalised between 0 and 1 and its
% negative scores are normalised between 0 and -1. Therefore each principal
% component is scaled between -1 and 1. 
% 
% usage: 
%     normalised = normbimodal();
% 
% where:
%     scores: a 2D or 3D matrix of scores values normscores: normalised
%     output with the same dimensionality as scores
%     
% Copyright (c) August 2011 Alex Henderson, alex.henderson@manchester.ac.uk


this = varargin{1};

if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. Prevents errors if the
    % function name changes
    command = [mfilename, '(obj,varargin{2:end});']; 
    eval(command);  
else
    % We are expecting to modified this object in situ

    pos = this.data;
    pos(pos<0) = 0;
    maxpos = max(max(pos));
    maxpos(maxpos == 0) = 1; % to prevent divide by zero errors
    pos = pos / maxpos;
        
    neg = this.data;
    neg(neg>0) = 0;
    neg = -neg;
    maxneg = max(max(neg));
    maxneg(maxneg == 0) = 1; % to prevent divide by zero errors
    neg = neg / maxneg;
  
    this.data = pos - neg; % subtract since we want the negative

    this.bimodal = true;
end
