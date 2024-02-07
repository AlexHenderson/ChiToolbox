function updatebutton_Callback(this,source,eventdata)  %#ok<INUSD>

% updatebutton_Callback  Calculates the model and displays the result
%
% Syntax
%   updatebutton_Callback(source,eventdata);
%
% Description
%   updatebutton_Callback(source,eventdata) is used internally to calculate
%   the model and display the result
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


    % Get values in edit boxes
    lambda = get(this.lambdahandle,'string');
    lambda = str2num(lambda); %#ok<ST2NM>
    % lambda needs to be a number, not the log10 of a number
    lambda = 10^lambda;
    
    asymm = get(this.asymmhandle,'string');
    asymm = str2num(asymm); %#ok<ST2NM>

    penaltystring = get(this.penaltyhandle,'string');
    if contains(penaltystring, '.')
        % Penalty needs to be an integer
        msgbox('Penalty must be an integer', 'Help','help');
        return
    else
        penalty = str2num(get(this.penaltyhandle,'string')); %#ok<ST2NM>
        this.penalty = penalty;
        this.lambda = lambda;
        this.asymm = asymm;
    end

    calculatedbaseline = this.calculate(this.datatomodel);
    corrected = this.datatomodel.clone();
    corrected.data = this.datatomodel.data - calculatedbaseline;

    this.datatomodel.plot('nofig', 'axes', this.axes_before);
    hold(this.axes_before, 'on');
    utilities.plotformatted(this.axes_before, this.datatomodel.xvals, calculatedbaseline);
    hold(this.axes_before, 'off');

    corrected.plot('nofig', 'axes', this.axes_after);

end
