function handle = imagepc(this,pc,varargin)

% imagepc  Creates an image of the score on the selected principal component.
%
% Syntax
%   imagepc(this,pc);
%   imagepc(____, 'nonorm');
%   imagepc(____, 'invert');
%   imagepc(____, 'nofig');
%   handle = imagepc(____);
%
% Description
%   imagepc(this,pc) creates an image of the score on the selected
%   principal component. The positive and negative going scores are each
%   normalised to unity.
% 
%   imagepc(____, 'nonorm') creates an image of the score without
%   normalisation.
%
%   imagepc(____, 'invert') multiplies the data by -1 to invert the
%   direction of the scores. This can be useful when comparing different
%   packages. Do not forget to invert the loading of the specified
%   principal component also. 
%
%   handle = imagepc(____) returns a handle to this figure.
% 
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImagePCAOutcome ChiPicture  imagesc

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% ToDo: handle masked data

    % Get user defined options
    invert = false;
    normalise = true;

    argposition = find(cellfun(@(x) strcmpi(x, 'invert') , varargin));
    if argposition
        varargin(argposition) = [];
        invert = ~invert;
    end

    argposition = find(cellfun(@(x) strcmpi(x, 'nonorm') , varargin));
    if argposition
        varargin(argposition) = [];
        normalise = ~normalise;
    end

    if ~isempty(this.loadings)
        % Do we need a new figure
        argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
        if argposition
            varargin(argposition) = [];
        else
            if nargout
                handle = figure;
            else
                figure;
            end
        end
        
        if (pc > this.numpcs)
            err = MException('CHI:ChiImagePCAOutcome:OutOfRange', ...
                ['Requested principal component is out of range. Max PCs = ', num2str(this.numpcs), '.']);
            throw(err);
        end

        scores3d = reshape(this.scores,this.height,this.width,this.numpcs);
        pc_to_plot = scores3d(:,:,pc);

        window_title = ['Score on principal component ', int2str(pc)];
        figure_title = ['Score on principal component ', int2str(pc)];

        if invert
            pc_to_plot = pc_to_plot * -1;
            window_title = [window_title, ' (inverted)'];
            figure_title = [figure_title, ' (inverted)'];
        end

        pic = ChiPicture(pc_to_plot);

        if normalise
            pic.normbimodal();
        end

        pic.imagesc(varargin{:});

        fig = gcf;
        fig.Name = window_title;
        fig.NumberTitle = 'off';
        
        title(figure_title);
        set(gca,'XTickLabel','');
        set(gca,'YTickLabel','');
        colorbar;        
        
    end

end

