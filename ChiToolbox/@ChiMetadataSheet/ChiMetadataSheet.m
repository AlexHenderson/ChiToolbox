classdef ChiMetadataSheet < ChiBase

% ChiMetadataSheet  Metadata Excel file reader

    properties
        title
        owner
        version
        datapath
        filenames = {};
        acquisitiondate
        metadatafile
        filter
        numparameters
        membershipnames    
        safemembershipnames
        parametertypes    
        classmemberships
        history
    end
    
    properties (Dependent = true)
        fullfilenames
        numfiles
    end
    
    methods (Static)
        function truefalse = isreadable(filename)
            if iscell(filename)
                filename = filename{1};
            end
            truefalse = false;
            
            % Check extension
            [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
            if ~strcmpi(ext(1:4),'.xls')
                return
            end
            
            % Check we have a Metadata Record Sheet            
            [num,txt] = xlsread(filename,'A1:A1'); %#ok<ASGLU>
            if ~strcmpi(txt,'Metadata Record Sheet')
                return;
            end
            
            truefalse = true;
        end
    end

    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function this = ChiMetadataSheet(varargin)
            if (nargin > 0) % Support calling with 0 arguments

                this.read(varargin{:});
%                 this.history = ChiLogger();
% 
%                 met = this.metadatareader(varargin{:});
% 
%                 this.title = met.title;
%                 this.owner = met.owner;
%                 this.datapath = met.dataPath;
%                 this.filenames = met.filenames;
%                 this.acquisitiondate = met.acquisitionDate;
%                 this.metadatafile = met.metadataFile;
%                 this.filter = met.filter;
%                 this.numparameters = met.numParameters;
%                 this.membershipnames = met.originalParameterNames;
%                 this.parametertypes = met.parameterTypes;
%                 this.safemembershipnames = met.safeParameterNames;
% 
%                 this.classmemberships = cell(this.numparameters,1);
%                 for i = 1:this.numparameters
%                     this.classmemberships{i} = ChiClassMembership(this.membershipnames{i},met.parameters{i});
%                 end
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function open(this,filename)
            
            if exist('filename', 'var')
                if ~ChiMetadataSheet.isreadable(filename)
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'Filename does not appear to be a Metadata Record Sheet.');
                    throw(err);
                end
                met = this.metadatareader(filename);
            else
                met = this.metadatareader();
            end

            this.title = met.title;
            this.owner = met.owner;
            this.version = met.version;
            this.datapath = met.dataPath;
            this.filenames = met.filenames;
            this.acquisitiondate = met.acquisitionDate;
            this.metadatafile = met.metadataFile;
            this.filter = met.filter;
            this.numparameters = met.numParameters;
            this.membershipnames = met.originalParameterNames;
            this.parametertypes = met.parameterTypes;
            this.safemembershipnames = met.safeParameterNames;

            this.classmemberships = cell(this.numparameters,1);
            for i = 1:this.numparameters
                this.classmemberships{i} = ChiClassMembership(this.membershipnames{i},met.parameters{i});
            end
                    
            this.history = ChiLogger();
            this.history.add(['Filename: ',this.metadatafile]);

        end                    
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function read(this,varargin)
            this.open(varargin{:});
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%         function duplicate = clone(this)
%             % from https://uk.mathworks.com/matlabcentral/newsreader/view_thread/257925            
%             % Instantiate new object of the same class.
%             
%             duplicate = feval(class(this));
%  
%             % Copy all non-hidden properties.
%             p = properties(this);
%             for i = 1:length(p)
%                 % Need a (MUCH BETTER) way of isolating/detecting dependent
%                 % properties
%                 if ~(strcmpi(p{i},'fullfilenames') || strcmpi(p{i},'numfiles'))
%                     duplicate.(p{i}) = this.(p{i});
%                 end
%             end
%         end            
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function m = membership(this,which)
            m = [];
            if isnumeric(which)
                m = this.classmemberships{which};
            else
                if ischar(which)
                    for i = 1:this.numparameters
                        if strcmpi(this.membershipnames{i},which)
                            m = this.classmemberships{i};
                        end
                    end
                    
                    if isempty(m)
                        % https://uk.mathworks.com/matlabcentral/answers/130695-how-can-i-return-a-char-of-object-variable-name-from-a-method
                        name = evalin('caller','inputname(1)');
                        err = MException(['CHI:',mfilename,':UnknownInput'], ...
                            'Membership name ''%s'' not recognised. Use ''%s.membershipnames()'' to view options.',...
                            which, name);
%                             ['Membership name ''', which, ''' not recognised. Use ''', name, '.membershipnames()'' to view options.']);
                        throw(err);
                    end
                else
                    err = MException(['CHI:',mfilename,':UnknownInput'], ...
                        'Enter the name of the membership as a string, or its position number.');
                    throw(err);
                end
            end
        end
        
    end

    methods % Dependent
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function fullfilenames = get.fullfilenames(this)
            if ~isempty(this.filenames)
                if isempty(this.datapath)
                    fullfilenames = this.filenames;
                else
                    fullfilenames = fullfile(this.datapath,this.filenames);
                end
            else
                fullfilenames = [];
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numfiles = get.numfiles(this)
            numfiles = size(this.filenames,1);
        end        
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
