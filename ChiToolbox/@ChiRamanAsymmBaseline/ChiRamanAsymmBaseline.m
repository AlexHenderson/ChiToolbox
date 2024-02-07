classdef ChiRamanAsymmBaseline < ChiAbstractRamanBaseline
    
% ChiRamanAsymmBaseline  Asymmetric least squares baseline modelling with optional GUI. 
%
% Syntax
%   baseline = ChiRamanAsymmBaseline(parent);
%
% Description
%   baseline = ChiRamanAsymmBaseline(parent) creates a Raman baseline model
%   using the asymmetric least squares approach. parent is the Raman data
%   from which a baseline should be removed. 
% 
%   This class can be used internally by Raman based data sets to define a
%   baseline. 
% 
%   The user is given the option of defining the parameters (lambda,
%   asymmetry and penalty) programmatically, or determining them using a
%   graphical interface. Once parameters are defined, each spectrum in the
%   data can be fitted using the model and the appropriate baseline
%   removed from each. Default parameters are provided (. 
%
% Notes
%   This code is based on a paper by Paul H. C. Eilers 
%   Analytical Chemistry 76 (2004) 404-411 
%   https://doi.org/10.1021/ac034800e
%   The actual implementation is taken from
%   https://github.com/Biospec/cluster-toolbox-v2.0
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   remove

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    properties
        lambda
        asymm
        penalty        

        defaultlambda  = 1e6;
        defaultasymm   = 0.001;
        defaultpenalty = 2;
    end

    properties (Hidden)
        % For GUI
        window 
        axes_before 
        axes_after 
        lambdahandle 
        asymmhandle  
        penaltyhandle
        acceptbaseline = false;
        
        datatomodel    
        parent
    end
    
    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function this = ChiRamanAsymmBaseline(parent)
            if nargin
                this.setparent(parent);
            end
            this.reset();
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end

