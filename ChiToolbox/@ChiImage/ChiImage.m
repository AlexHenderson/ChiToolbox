classdef ChiImage < ChiAbstractImage
% classdef ChiImage < handle & ChiSpectralCharacter & ChiSpatialCharacter
% ChiImage Storage class for hyperspectral images
% Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)
    
    % matlab.mixin.Copyable only for >R2011a
    % Want compatibility with R2009a
    
    properties  
        xvals;      % Abscissa as a row vector
        data;       % Contents of object as a 2D matrix, spectra in rows
        xpixels;    % Number of pixels in the x-direction (width)
        ypixels;    % Number of pixels in the y-direction (height)
        reversex = false;   % Should abscissa be plotted in decreasing order
        xlabelname = ''; % Text for abscissa label on plots
        xlabelunit = ''; % Text for the abscissa label unit on plots
        ylabelname = ''; % Text for ordinate label on plots
        ylabelunit = ''; % Text for the ordinate label unit on plots
        mask;  
        masked = false;
        filenames = {};         % Name of the file, if appropriate
        history = ChiLogger();  % Log of data processing steps
    end

    properties (Dependent = true)
        totalspectrum;  % Sum of columns of data
        totalimage;     % Sum of layers of data
    end

    % =====================================================================
    methods (Static)
    % =====================================================================
        function spectrumclassname = spectrumclassname()
            spectrumclassname = 'ChiSpectrum';
        end
    end        
        
    % =====================================================================
    methods
    % =====================================================================
        % Constructor
        function this = ChiImage(xvals,data,xpixels,ypixels,reversex,xlabelname,xlabelunit,ylabelname,ylabelunit,masked,mask,filenames,varargin)
            % Create an instance of ChiImage with given parameters
            
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            else
                this.history = ChiLogger();
            end
            
            this.spectrumclassname = 'ChiSpectrum';
            this.spectralcollectionclassname = 'ChiSpectralCollection';
            
            this.ontologyinfo = ChiOntologyInformation();
            this.ontologyinfo.term = 'chemical map';
            this.ontologyinfo.description = ['A data set derived from ' ...
                'microspectroscopy consisting of a three-dimensional ' ...
                'image where two axes describe the x and y spatial ' ...
                'dimensions and the third dimension represents ' ...
                'spectral wavelength. The image is obtained by ' ...
                'stacking one image per spectral wavelength ' ...
                'sequentially. [database_cross_reference: ' ...
                'http://www.spectroscopyeurope.com/NIR_14_3.pdf].'];
            this.ontologyinfo.uri = 'http://purl.obolibrary.org/obo/CHMO_0001891';
            this.ontologyinfo.isaccurate = true;
            
            if (nargin > 0) % Support calling with 0 arguments
                this.xvals = xvals;
                this.data = data;
                
                % Force to row vector
                this.xvals = utilities.force2row(this.xvals);
                
                if (nargin > 2)
                    this.xpixels = xpixels;
                    this.ypixels = ypixels;
                    if (nargin > 4)
                        this.reversex = reversex;
                        if (nargin > 5)
                            this.xlabelname = xlabelname;
                            this.xlabelunit = xlabelunit;
                            this.ylabelname = ylabelname;
                            this.ylabelunit = ylabelunit;
                            if (nargin > 9)
                                this.masked = masked;
                                this.mask = mask;
                                if (nargin > 11)
                                    this.filenames = filenames;
                                end
                            end
                        end
                    end
                end
                
                % Reshape data into a 2D array
                [dims] = size(this.data);
                switch (length(dims))
                    case 1
                        % vector of intensities 
                        this.data = reshape(this.data,ypixels*xpixels,[]);
                    case 2
                        % 2D so probably don't need to reshape
                        % this.data = reshape(this.data,this.ypixels*this.xpixels,[]);
                        % TODO: Check xpixels and ypixels are valid
                    case 3
                        % 3D data so unfold array
                        this.ypixels = dims(1);
                        this.xpixels = dims(2);
                        chans = dims(3);
                        this.data = reshape(this.data,this.ypixels*this.xpixels,chans);
                    otherwise
                        % Too many or too few dimensions. 
                        err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                            'Data is not 1D, 2D or 3D');
                        throw(err);
                end
            end 
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function totalspectrum = get.totalspectrum(this)
            spectrumclass = str2func(this.spectrumclassname);
            totalspectrum = spectrumclass(this.xvals,sum(this.data),this.reversex,this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit);
            totalspectrum.filenames = this.filenames;
        end                
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function totalimage = get.totalimage(this)
                        
            if this.masked
                unmasked = zeros(this.xpixels*this.ypixels, this.numchannels);
                totindex = 1;
                for i = 1:length(this.mask)
                    if this.mask(i)
                        % Insert the non-zero values back into the required
                        % locations. 
                        unmasked(i,:) = this.data(totindex,:);
                        totindex = totindex + 1;
                    end
                end
                totrows = sum(unmasked,2);
            else
                totrows = sum(this.data,2);
            end
            
            totalimage = ChiPicture(totrows,this.xpixels,this.ypixels);
        end        
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end % methods
end % class ChiImage 

