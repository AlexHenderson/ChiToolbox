function obj = normscores(varargin)

% function normscores
% 
% A scores matrix contains positive and negative values that have different
% maxima (minima). Here we normalise each principal component separately
% such that its positive scores are normalised between 0 and 1 and its
% negative scores are normalised between 0 and -1. Therefore each principal
% component is scaled between -1 and 1. 
% 
% usage: 
%     normalised = normscores(scores);
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

    posscores = this.scores;
    posscores(posscores<0) = 0;
    maxscore = max(posscores);
    maxscore(maxscore == 0) = 1; % to prevent divide by zero errors
    invmaxscore = 1./maxscore;
    spdmax = spdiags(invmaxscore', 0, length(invmaxscore), length(invmaxscore));
    normposscores = posscores*spdmax;

    negscores = this.scores;
    negscores(negscores>0) = 0;
    negscores = -negscores;
    minscore = max(negscores);
    minscore(minscore == 0) = 1; % to prevent divide by zero errors
    invminscore = 1./minscore;
    spdmin = spdiags(invminscore', 0, length(invminscore), length(invminscore));
    normnegscores = negscores*spdmin;

%     this.scores = this.scores - normnegscores;
    this.scores = normposscores - normnegscores;

end
