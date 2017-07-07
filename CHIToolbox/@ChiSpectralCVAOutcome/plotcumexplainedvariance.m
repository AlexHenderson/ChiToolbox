function plotcumexplainedvariance(this,limitpcs)

% plotcumexplainedvariance Plots cumulative percentage explained variance
% usage:
%     plotcumexplainedvariance(this);
%     plotcumexplainedvariance(this, limitpcs);
%
% where:
%   limitpcs - (optional) by default the function plots the first 20 pcs. If
%       'limitpcs' is present then this determines the number of principal
%       components displayed
%
%   Copyright (c) 2015-2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 2.0 July 2017

%   version 2.0 July 2017 Alex Henderson
%   Modified as a class function
%   version 1.0 June 2015 Alex Henderson
%   initial release

this.PCAOutcome.plotcumexplainedvariance(this, limitpcs);

end
