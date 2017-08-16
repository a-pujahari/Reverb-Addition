%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%------------------------ MushraComments.m -------------------------------
%/////////////////////////////////////////////////////////////////////////

function MushraComments(experimentNumber, numExperiments)

% define window dimensions
figHeight = 260;
figWidth = 500;

% get screen info and hence window positions
screenSize = get(0, 'ScreenSize');
screenWidth = screenSize(3);
screenHeight = screenSize(4);
windowX = screenWidth/2 - figWidth/2;
windowY = screenHeight/2 - figHeight/2;

% create comment window
windowColour = [102 139 139]/255;
fig = figure('Position', [windowX, windowY, figWidth, figHeight], 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'Mushra - Comments', 'NumberTitle', 'off', 'Resize', 'off', 'Color', windowColour, 'CloseRequestFcn', 'MushraCommentsCallbacks(''closeWindow'')');

% create comment text box
global commentBox;
commentBox = uicontrol(fig, 'Style', 'edit', 'Position', [50, 70, 400, 120], 'Min', 1, 'Max', 20, 'BackgroundColor', 'white', 'String', '');

% create title
uicontrol(fig, 'Style', 'text', 'String', ['Experiment ' num2str(experimentNumber) ': Comments'], 'Position', [50, 220, 400, 30], 'FontSize', 16, 'FontWeight', 'bold', 'BackgroundColor', windowColour);

% some instructions
uicontrol(fig, 'Style', 'text', 'String', ['Please write any comments you have about experiment ' num2str(experimentNumber), '.'], 'Position', [50, 190, 400, 30], 'FontSize', 12, 'BackgroundColor', windowColour);

% create submit button
uicontrol(fig, 'Style', 'pushbutton', 'String', 'Submit', 'Position', [200, 20, 100, 30], 'Callback', ['MushraCommentsCallbacks(''submit'',' num2str(experimentNumber) ',' num2str(numExperiments) ')']);