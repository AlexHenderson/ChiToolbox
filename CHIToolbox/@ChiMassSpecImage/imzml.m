function imzml(varargin)

% imzml  Saves data in the imzML file format. 
%
% Syntax
%   imzml();
%   imzml(Name,Value);
%   imzml(____,filename);
%
% Description
%   imzml() requests a filename from the user to save the imzml files
%   (.imzml/.ibd pair) to. The data is assumed to be positive ion and not
%   centroided. The output files are saved to the same location as the
%   original data. 
% 
%   imzml(____,filename) saves the .imzml/.ibd files using the filename
%   provided. For example, C:\data\mydata.imzml
%
%   imzml(Name,Value) allows for Name/Value pairs.
%       Name = 'polarity', Value is either 'pos' or 'neg' for positive ion
%       or negative ion data respectively. Default = 'pos'. 
%       Name = 'centroid', Value is either true or false depending on
%       whether the data has been centroided. Default = false.
%       Example
%           j105data.imzml('polarity','neg', 'centroid',true);
% 
% Notes
%   Writing an imzml/ibd file pair takes a LONG TIME and uses A LOT of disc
%   space. Just sayin'...
% 
%   If the data is centroided (peak-picked) the number of peaks per pixel
%   must be the same for all pixels. 
% 
%   More information on the imzml file format is available from
%   https://ms-imaging.org/wp/imzml/
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
% 
% See also 
%   ChiToFMassSpecimage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

% Info...
% https://ms-imaging.org/wp/wp-content/uploads/2009/08/specifications_imzML1.1.0_RC1.pdf

% This version of the code is designed to write peaks that have been
% identified from the total ion spectrum with their limits applied to each
% pixel. Therefore the lengths of the mz array and intensity array are the
% same for every pixel.
% If the method of selecting peaks changes then we will need to modify this
% code to write different length mzarrays for each pixel. 
% Of course, for each pixel the number of mz values is the same as the
% number of intensity values, but these could change from pixel-to-pixel. 


this = varargin{1};

if strcmpi(this.imzmlproperties.instrument, 'Ionoptika J105')
    
    isPositiveIon = true;
    isCentroided = false;
    filename = '';

    polarity = 'pos';

    argposition = find(cellfun(@(x) strcmpi(x, 'polarity') , varargin));
    if argposition
        polarity = varargin{argposition+1};
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end

    argposition = find(cellfun(@(x) strcmpi(x, 'centroid') , varargin));
    if argposition
        isCentroided = varargin{argposition+1};
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end

    if (length(varargin) > 1)
        filename = varargin{2};
    else
        % We can only handle Ionoptika J105 data at the moment. 
        % Input filename of the form: C:\MyData\stub.0000_000_000.h5
        %   or: C:\MyData\stub.0000_000_000
        % Wish to generate: C:\MyData\stub.imzml
        % Therefore remove the last one/two extensions and append .imzml
        expr = '^(.+)\.\d{4}_\d{3}_\d{3}.*';
        [start_idx, end_idx, extents, matches, tokens] = regexp(this.filename, expr); %#ok<ASGLU>
        stub = tokens{1,1}{1,1};
        filename = [stub,'.imzml'];
    end

    switch lower(polarity(1))
        case 'p'
            isPositiveIon = true;
        case 'n'
            isPositiveIon = false;
        otherwise
            err = MException(['CHI:',mfilename, 'InputError'], ...
                'Polarity should be either ''pos'' or ''neg''.');
            throw(err);
    end

    j105toimzml(this.mass, this.data, this.width, this.height, ...
                isPositiveIon, isCentroided, filename);

else
    err = MException(['CHI:',mfilename, 'InputError'], ...
        'imzML output is only avilable for Ionoptika J105 files at the moment.');
    throw(err);
end    
