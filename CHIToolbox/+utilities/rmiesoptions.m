classdef rmiesoptions < handle

% rmiesoptions  Resonant Mie scattering correction options
%
% Syntax
%   options = rmiesoptions();
%   options = rmiesoptions(Name,Parameter);
% 
% Description
%   options = rmiesoptions() creates a rmiesoptions object with default
%   values for options (see below).
% 
%   options = rmiesoptions(Name,Parameter) creates a rmiesoptions object
%   with default values except for the Name,Parameter pairs provided.
% 
% Default values:
%     desired_res = 0;          Desired resolution (0 keeps original resolution)
%     lower_wavenumber = 1000;  Lower wavenumber range (min value is 1000)
%     upper_wavenumber = 4000;  Upper wavenumber range (max value is 4000)
%     iterations = 1;           Number of iterations
%     mie_theory = 2;           Mie theory option ('smooth' == 1 or 'RMieS' == 2)
%     numpcs = 8;               Number of principal components used (8 recommended)
%     lower_diam = 2;           Lower range for scattering particle diameter/um
%     upper_diam = 8;           Upper range for scattering particle diamter/um
%     lower_ri = 1.1;           Lower range for average refractive index
%     upper_ri = 1.5;           Upper range for average refractive index
%     spacings = 10;            Number of values for each scattering parameter default 10
%     orthogonalisation = 1;    Orthogonalisation ('No' == 0, 'Yes' == 1) (1 recommended)
%     reference = 1;            Which reference spectrum ('Matrigel' == 1, 'Simulated' == 2)
% 
%   For more information on the parameters and their usage, see the
%   readme.md file on the Github repository
%   https://github.com/GardnerLabUoM/RMieS/blob/master/README.md
%
% Copyright (c) 2014-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   RMieS_EMSC_v5.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, March 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties
        % See below for information on these defaults
        desired_res = 0;
        lower_wavenumber = 1000;
        upper_wavenumber = 4000;
        iterations = 1;
        mie_theory = 2;
        numpcs = 8;
        lower_diam = 2;
        upper_diam = 8;
        lower_ri = 1.1;
        upper_ri = 1.5;
        spacings = 10;
        orthogonalisation = 1;
        reference = 1;
        
        % These two were not in Paul Bassan's original version
        optionsversion = 2;
        savehistory = 0;
    end
    
    methods
        function this = rmiesoptions(varargin)
            % Create an instance of rmiesoptions with given parameters
            
            if (nargin > 0) % Support calling with 0 arguments
                if(nargin == 1)
                    if (isvector(varargin{1}))
                        % We have received one of the original Bassan options
                        % vectors
                        opt = varargin{1};
                        this.desired_res = opt(1);
                        this.lower_wavenumber = opt(2);
                        this.upper_wavenumber = opt(3);
                        this.iterations = opt(4);
                        this.mie_theory = opt(5);
                        this.numpcs = opt(6);
                        this.lower_diam = opt(7);
                        this.upper_diam = opt(8);
                        this.lower_ri = opt(9);
                        this.upper_ri = opt(10);
                        this.spacings = opt(11);
                        this.orthogonalisation = opt(12);
                        this.reference = opt(13);

                        this.optionsversion = 1;
                        this.savehistory = 1;
                    else
                        if(isa(varargin{1},'rmiesoptions'))
                            % We have received one of these classes
                            % TODO
                        else
                            err = MException('RMieS:InputError', ...
                                'Input neither a vector nor an options class');
                            throw(err);
                        end
                    end
                end
                
                if(nargin > 1)
                    if(rem(nargin,2))
                        err = MException('RMieS:InputError', ...
                            'Options should be in pairs');
                        throw(err);
                    else
                        % We must have parameters in pairs
                        unused = ones(nargin,1);
                        varargin = reshape(varargin,[],2);
                        for argnum = 1:nargin
                            switch (varargin{argnum,1})
                                case 'desired_res'
                                    this.desired_res = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'lower_wavenumber'
                                    this.lower_wavenumber = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'upper_wavenumber'
                                    this.upper_wavenumber = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'iterations'
                                    this.iterations = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'mie_theory'
                                    this.mie_theory = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'numpcs'
                                    this.numpcs = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'lower_diam'
                                    this.lower_diam = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'upper_diam'
                                    this.upper_diam = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'lower_ri'
                                    this.lower_ri = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'upper_ri'
                                    this.upper_ri = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'spacings'
                                    this.spacings = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'orthogonalisation'
                                    this.orthogonalisation = varargin{argnum,2};
                                    unused(argnum) = 0;
                                case 'reference'
                                    this.reference = varargin{argnum,2};
                                    unused(argnum) = 0;
                            end
                            % Make sure we understood everything
                            unused = reshape(unused,[],2);
                            problems = find(unused(:,1));
                            if(~empty(problems))
                                message = ['Could not understand the following entries: ', num2str(problems)];
                                err = MException('RMieS:InputError', message);
                                throw(err);
                            end
                        end
                    end
                end
            end
        end % function constructor
        
        function set.mie_theory(this, val)
            if(ischar(val))
                switch (lower(val))
                    case 'smooth'
                        this.mie_theory = 1;
                    case 'rmies'
                        this.mie_theory = 2;
                    otherwise
                        err = MException('RMieS:InputError', ...
                            'mie_theory options are 1 or 2 or ''smooth'' or ''rmies''');
                        throw(err);
                end
            else
                switch (val)
                    case 1
                        this.mie_theory = 1;
                    case 2
                        this.mie_theory = 2;
                    otherwise
                        err = MException('RMieS:InputError', ...
                            'mie_theory options are 1 or 2 or ''smooth'' or ''rmies''');
                        throw(err);
                end
            end
        end % set.mie_theory
        
        function set.orthogonalisation(this, val)
            if(ischar(val))
                switch (lower(val))
                    case 'no'
                        this.orthogonalisation = 0;
                    case 'yes'
                        this.orthogonalisation = 1;
                    otherwise
                        err = MException('RMieS:InputError', ...
                            'orthogonalisation options are 0 or 1 or ''no'' or ''yes''');
                        throw(err);
                end
            else
                switch (val)
                    case 1
                        this.orthogonalisation = 0;
                    case 2
                        this.orthogonalisation = 1;
                    otherwise
                        err = MException('RMieS:InputError', ...
                            'orthogonalisation options are 0 or 1 or ''no'' or ''yes''');
                        throw(err);
                end
            end
        end % set.orthogonalisation
        
        function set.reference(this, val)
            if(ischar(val))
                switch (lower(val))
                    case 'matrigel'
                        this.reference = 1;
                    case 'simulated'
                        this.reference = 2;
                    otherwise
                        err = MException('RMieS:InputError', ...
                            'reference options are 1 or 2 or ''matrigel'' or ''simulated''');
                        throw(err);
                end
            else
                switch (val)
                    case 1
                        this.reference = 1;
                    case 2
                        this.reference = 2;
                    otherwise
                        err = MException('RMieS:InputError', ...
                            'reference options are 1 or 2 or ''matrigel'' or ''simulated''');
                        throw(err);
                end
            end
        end % set.reference
        
        function opt = exportv1(this)
            % Converts this class structure to a simple vector suitable for
            % the original rmies code. 
            opt = [this.desired_res;
                    this.lower_wavenumber;
                    this.upper_wavenumber;
                    this.iterations;
                    this.mie_theory;
                    this.numpcs;
                    this.lower_diam;
                    this.upper_diam;
                    this.lower_ri;
                    this.upper_ri;
                    this.spacings;
                    this.orthogonalisation;
                    this.reference];
        end % exportv1

    end % methods
end % class def

% Original correction_options vector
%
% correction_options = [ ...
%     0    ;      % 1. Desired resolution, (0 keeps original resolution)
%     1000 ;      % 2. Lower wavenumber range (min value is 1000)
%     4000 ;      % 3. Upper wavenumber range (max value is 4000)
%     1    ;      % 4. Number of iterations
%     2    ;      % 5. Mie theory option (smooth or RMieS)
%     7    ;      % 6. Number of principal components used (8 recommended)
%     2    ;      % 7. Lower range for scattering particle diameter / um
%     8    ;      % 8. Upper range for scattering particle diamter / um
%     1.1  ;      % 9. Lower range for average refractive index
%     1.5  ;      % 10. Upper range for average refractive index
%     10   ;      % 11. Number of values for each scattering parameter default 10
%     1    ;      % 12. Orthogonalisation, 0 = no, 1 = yes. (1 recommended)
%     1   ];      % 13. Which reference spectrum, 1 = Matrigel, 2 = Simulated
% 
