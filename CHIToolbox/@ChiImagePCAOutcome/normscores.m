function normscores=normscores(this,scores)

% function normalisescores
% 
% A scores matrix contains positive and negative values that have different
% maxima (minima). Here we normalise each principal component separately
% such that its positive scores are normalised between 0 and 1 and its
% negative scores are normalised between 0 and -1. Therefore each principal
% component is scaled between -1 and 1. 
% 
% usage: 
%     normscores=normalisescores(scores);
% 
% where:
%     scores: a 2D or 3D matrix of scores values normscores: normalised
%     output with the same dimensionality as scores
%     
% Copyright (c) August 2011 Alex Henderson, alex.henderson@manchester.ac.uk

[scoredims]=size(scores);

numberofdims=length(scoredims);

if (numberofdims < 2) ||(numberofdims > 3)
    error('scores matrix should be either 2D or 3D');
end

if numberofdims==3
    scores=reshape(scores, scoredims(1) * scoredims(2), []);
end

posscores=scores;
posscores(posscores<0) = 0;
maxscore=max(posscores);
maxscore(maxscore == 0) = 1;
invmaxscore=1./maxscore;
spdmax=spdiags(invmaxscore', 0, length(invmaxscore), length(invmaxscore));
normscores=posscores*spdmax;

negscores=scores;
clear scores;
negscores(negscores>0)=0;
negscores = -negscores;
minscore=max(negscores);
minscore(minscore == 0) = 1;
invminscore=1./minscore;
spdmin=spdiags(invminscore', 0, length(invminscore), length(invminscore));
normnegscores=negscores*spdmin;

normscores=normscores - normnegscores;

if numberofdims==3
    normscores=reshape(normscores, scoredims(1), scoredims(2), []);
end
