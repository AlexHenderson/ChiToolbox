function baseline_correction(tics)

% Interactive Baseline Correction software
% baseline_correction(tics)
% tics: a matrix contains all chromatograms and each row represents one
% chromatogram.
% Based on Asymmetric Least Square algorithm, Paul Eilers, 2002
% Yun Xu, 06/Dec./2005

global fig_h title_text axe_superimpose axe_bc edt_lamda edt_p d button_show button_accept;
fig_h=figure('Toolbar','figure',...
              'Menubar', 'figure',...
              'Name','Base Line Correction',...
              'NumberTitle','off',...
              'IntegerHandle','off',...
              'Units','normalized',...
              'Position',[0.1 0.1 0.75 0.8],...
              'Tag','Base_Line');
axe_superimpose=axes('position',[0.1 0.55 0.7 0.35]);  
title_superimpose=title(axe_superimpose,'Chromatogram before baseline correction', ...
    'FontSize', 14);
axe_bc=axes('position',[0.1 0.1 0.7 0.35]);
title_bc=title(axe_bc,'Chromatogram after baseline correction', 'FontSize', 14);
no_chroms=size(tics,1);
disp_string=['No. ' num2str(1) ', ' num2str(no_chroms) ' chromatogram(s) in total']; 
title_text=uicontrol('Parent', fig_h,...
    'Units', 'normalized',...
    'Position',[.12 .96 .6 .028],...
    'String',disp_string,...
    'FontSize', 14,...
    'FontWeight', 'bold',...
    'Style','Text',...
    'Tag','tip_text');
lamda=1e8; p=0.001; d=2;
txt_lamda=uicontrol('Parent', fig_h,...
    'Units', 'normalized',...
    'Position',[0.85 0.83 0.1 0.04],...
    'String', 'Smoothing Parameter',...
    'Style','Text',...
    'Tag', 'txt_lamda');
edt_lamda=uicontrol('Parent', fig_h,...
    'Units', 'normalized',...
    'Position',[0.85 0.8 0.1 0.025],...
    'String',num2str(lamda),...
    'Style','Edit',...
    'BackgroundColor',[1 1 1],...    
    'Tag', 'edt_lamda');
txt_p=uicontrol('Parent', fig_h,...
    'Units', 'normalized',...
    'Position',[0.85 0.73 0.1 0.04],...
    'String', 'Asymmetry Parameter',...
    'Style','Text',...
    'Tag', 'txt_p');
edt_p=uicontrol('Parent', fig_h,...
    'Units', 'normalized',...
    'Position',[0.85 0.7 0.1 0.025],...
    'String',num2str(p),...
    'Style','Edit',...
    'BackgroundColor',[1 1 1],...    
    'Tag', 'edt_p');
button_show=uicontrol('Parent', fig_h,...
    'Units', 'normalized',...
    'Position',[0.85 0.4 0.1 0.03],...
    'String','Show',...
    'Style','PushButton',...
    'CallBack','func_show',...
    'Tag', 'button_show');
button_accept=uicontrol('Parent', fig_h,...
    'Units', 'normalized',...
    'Position',[0.85 0.3 0.1 0.03],...
    'String','Accept',...
    'Style','PushButton',...
    'CallBack','func_accept',...
    'Tag', 'button_show');
prog.chroms=tics;
prog.point=1;
prog.temp_tic=asysm(tics(1,:)',lamda,p,d);
prog.temp_tic=prog.temp_tic';
set(fig_h,'UserData',prog);
plot(axe_superimpose,tics(1,:));
hold(axe_superimpose,'on');
plot(axe_superimpose,prog.temp_tic,'r');
hold(axe_superimpose,'off');
plot(axe_bc,tics(1,:)-prog.temp_tic);