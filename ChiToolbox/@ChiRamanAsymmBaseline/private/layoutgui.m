function layoutgui(this)

% layoutgui  Generates the gui window
%
% Syntax
%   layoutgui();
%
% Description
%   layoutgui() used internally to generate the gui window.
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    % Default is 80% of screen in both width and height, and centred. 
    screensize = get(0,'ScreenSize');
    screenleft  = screensize(1);
    screenbottom  = screensize(2);
    screenwidth  = screensize(3);
    screenheight = screensize(4);
    windowWidthSpacer = screenwidth / 10;
    windowHeightSpacer = screenheight / 10;

    wleft = screenleft + windowWidthSpacer;
    wbottom = screenbottom + windowHeightSpacer;
    wwidth = windowWidthSpacer * 8;
    wheight = windowHeightSpacer * 8;


    editpadding = 15;
    editspacing = 1;
    buttonsize = [130, 40];
    labellededitsize = buttonsize;

    params.fontsize = get(0,'DefaultUIControlFontSize');
    params.spacerstring = '';

    this.window = figure('Name', 'ChiToolbox : Asymmetric Least Squares Baseline', ...
                'OuterPosition',[wleft,wbottom,wwidth,wheight], ...
                'Units','pixels', ...    
                'MenuBar', 'none', ...
                'Toolbar', 'none', ...
                'NumberTitle', 'off');

    % The figure window contains a horizontal box that contains two vertical
    % boxes, one for the axes and one for the controls. The axes box contains
    % two axes only. The controls box contains five vertical boxes: 1,3 and 5
    % are empty and act as spacers. Number two contains three vertical button
    % boxes. Each of these contains a text label and an edit control. They're
    % grouped together to allow the spacing between the controls to be greater
    % than the spacing between the edit control and its text label. The fourth
    % vertical box contains two buttons.

    % Well nearly...

    % The controls vertical box is constrained in width so that the controls
    % remain the same size if the window is resized. 

    hbox = uix.HBox('Parent', this.window);

    axesbox = uix.VBox('Parent',hbox);
    this.axes_before = axes('Parent',axesbox, 'ActivePositionProperty','outerposition', 'Tag','axes_before');
    this.axes_after  = axes('Parent',axesbox, 'ActivePositionProperty','outerposition', 'Tag','axes_after');

    controlsbox = uix.VBox('Parent',hbox);
    controlswidth = 150;

    editbox = uix.VBox('Parent',controlsbox);

    lambdabox = uix.VButtonBox('Parent',editbox, 'HorizontalAlignment','center');
    this.createuicontrol(lambdabox,'text',params,'log10(Lambda) (def. 6)');
    this.lambdahandle = this.createuicontrol(lambdabox, 'edit', params, num2str(log10(this.lambda)));
    set(lambdabox, 'ButtonSize', labellededitsize, 'Padding', editpadding, 'Spacing', editspacing);

    asymmbox = uix.VButtonBox('Parent', editbox, 'HorizontalAlignment', 'center');
    this.createuicontrol(asymmbox, 'text', params, 'Asymmetry (def. 0.001)');
    this.asymmhandle = this.createuicontrol(asymmbox, 'edit', params, num2str(this.asymm));
    set(asymmbox, 'ButtonSize', labellededitsize, 'Padding', editpadding, 'Spacing', editspacing);

    penaltybox = uix.VButtonBox('Parent', editbox, 'HorizontalAlignment', 'center');
    this.createuicontrol(penaltybox, 'text', params, 'Penalty (default 2)');
    this.penaltyhandle = this.createuicontrol(penaltybox, 'edit', params, num2str(this.penalty));
    set(penaltybox, 'ButtonSize', labellededitsize, 'Padding', editpadding, 'Spacing', editspacing);

    buttonbox1 = uix.VButtonBox('Parent', controlsbox, 'HorizontalAlignment', 'center');
    this.createuicontrol(buttonbox1, 'button', params, 'Update', {@this.updatebutton_Callback});
    this.createuicontrol(buttonbox1, 'button', params, 'Reset', {@this.resetbutton_Callback});
    set(buttonbox1, 'ButtonSize', buttonsize, 'Spacing', 5);

        spacer1 = uix.VButtonBox('Parent', buttonbox1);
        this.createuicontrol(spacer1,'spacer',params);
        this.createuicontrol(spacer1,'spacer',params);
        spacer2 = uix.VButtonBox('Parent', buttonbox1);
        this.createuicontrol(spacer2,'spacer',params);
        this.createuicontrol(spacer2,'spacer',params);

    buttonbox2 = uix.VButtonBox('Parent', controlsbox, 'HorizontalAlignment', 'center');
    this.createuicontrol(buttonbox2, 'button', params, 'Subtract', {@this.subtractbutton_Callback});
    this.createuicontrol(buttonbox2, 'button', params, 'Cancel', {@this.cancelbutton_Callback});
    set(buttonbox2, 'ButtonSize', buttonsize, 'Spacing', 5);

    set(hbox, 'Widths', [-1, controlswidth]);
end
