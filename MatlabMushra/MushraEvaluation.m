%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%------------------------ MushraEvaluation.m -----------------------------
%/////////////////////////////////////////////////////////////////////////

function MushraEvaluation(experimentNumber)
% GUI for the Mushra Evaluation Phase

% get sample info again
global samples
sizeSamples = size(samples);
sizeSamples = sizeSamples(1:2);
numExperiments = sizeSamples(1);
samplesPerExperiment = sizeSamples(2);

% just incase an experiment which doesn't exist is run
if experimentNumber > numExperiments
    errordlg('There Aren''t That Many Experiments');
    return;
end

% define window dimensions
figHeight = 450;
figWidth = 140 + 70*samplesPerExperiment;

% get screen info and hence window positions
screenSize = get(0, 'ScreenSize');
screenWidth = screenSize(3);
screenHeight = screenSize(4);
windowX = screenWidth/2 - figWidth/2;
windowY = screenHeight/2 - figHeight/2;

% create window
windowColour = [102 139 139]/255;
fig = figure('Position', [windowX, windowY, figWidth, figHeight], 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'Mushra - Evaluation Phase', 'NumberTitle', 'off', 'Resize', 'off', 'Color', windowColour, 'CloseRequestFcn', 'MushraEvaluationCallbacks(''closeWindow'')');

% define some other colours
notPlayedColour = [172 23 31]/255;

% make some sliders, play buttons and various text boxes
uicontrol(fig, 'Style', 'text', 'Position', [(figWidth-130)/2 + 55, 380, 150, 20], 'BackgroundColor', windowColour, 'FontSize', 12, 'FontWeight', 'bold', 'String', 'Sample Number');
global buttonMatrix textMatrix sliderMatrix samplesOrder samplesPlayed prevPlayed;
buttonMatrix = zeros(1, samplesPerExperiment);
textMatrix = zeros(1, samplesPerExperiment);
sliderMatrix = zeros(1, samplesPerExperiment);
samplesOrder = randperm(samplesPerExperiment);
samplesPlayed = zeros(1, samplesPerExperiment);
prevPlayed = 0;
for sampleNumber = 1:samplesPerExperiment
    uicontrol(fig, 'Style', 'text', 'Position', [(140+(sampleNumber-1)*70), 350, 50, 20], 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', windowColour, 'String', num2str(sampleNumber));
    sliderMatrix(sampleNumber) = uicontrol(fig, 'Style', 'slider', 'Position', [(155+(sampleNumber-1)*70), 140, 20, 200], 'Min', 0, 'Max', 100, 'SliderStep', [0.1 0.01], 'Callback', ['MushraEvaluationCallbacks(''sliderMoved'',' num2str(sampleNumber) ')'], 'Enable', 'off');
    textMatrix(sampleNumber) = uicontrol(fig, 'Style', 'text', 'Position', [(140+(sampleNumber-1)*70), 110, 50, 20], 'FontSize', 12, 'BackgroundColor', windowColour, 'String', '0');
    buttonMatrix(sampleNumber) = uicontrol(fig, 'Style', 'pushbutton', 'Position', [(140+(sampleNumber-1)*70), 70, 50, 30], 'String', 'Play', 'BackgroundColor', notPlayedColour, 'Callback', ['MushraEvaluationCallbacks(''playSample'',' num2str(experimentNumber) ',' num2str(sampleNumber) ')']);
end

% add play reference button
global refPlayed playRef;
refPlayed = 0;
playRef = uicontrol(fig, 'Style', 'pushbutton', 'Position', [20, 70, 100, 30], 'String', 'Play Reference', 'BackgroundColor', notPlayedColour, 'Callback', ['MushraEvaluationCallbacks(''playReference'',' num2str(experimentNumber) ')']);

% add title
uicontrol(fig, 'Style', 'text', 'FontSize', 16, 'FontWeight', 'bold', 'String', ['Evaluation Phase: Experiment ' num2str(experimentNumber)], 'Position', [(figWidth/2) - 170, 410, 340, 35], 'BackgroundColor', windowColour);

% make it pretty with some lines
canvas = axes('Units', 'pixels', 'Position', [0, 0, figWidth, figHeight], 'Visible', 'off', 'Xlim', [0, figWidth], 'Ylim', [0, figHeight]);
for k = 155:34:325
    line(10:figWidth-10, k, 'Parent', canvas, 'Color', 'black');
end
line(10, 155:325, 'Parent', canvas, 'Color', 'black');
line(130, 155:405, 'Parent', canvas, 'Color', 'black');
line(figWidth-10, 155:405, 'Parent', canvas, 'Color', 'black');
for k = 1:samplesPerExperiment-1
    line(130 + k*70, 155:375, 'Parent', canvas, 'Color', 'black');
end
line(130:figWidth-10, 375, 'Parent', canvas, 'Color', 'black');
line(130:figWidth-10, 405, 'Parent', canvas, 'Color', 'black');

% add grade text
uicontrol(fig, 'Style', 'text', 'Position', [20, 162, 100, 20], 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', windowColour, 'String', 'Bad');
uicontrol(fig, 'Style', 'text', 'Position', [20, 196, 100, 20], 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', windowColour, 'String', 'Poor');
uicontrol(fig, 'Style', 'text', 'Position', [20, 230, 100, 20], 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', windowColour, 'String', 'Fair');
uicontrol(fig, 'Style', 'text', 'Position', [20, 264, 100, 20], 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', windowColour, 'String', 'Good');
uicontrol(fig, 'Style', 'text', 'Position', [20, 298, 100, 20], 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', windowColour, 'String', 'Excellent');

% add stop button
uicontrol(fig, 'Style', 'pushbutton', 'Position', [(figWidth/2)-160, 20, 150, 30], 'String', 'Stop Audio', 'CallBack', 'MushraEvaluationCallbacks(''stopAudio'')');

% add proceed button
global proceed;
proceed = uicontrol(fig, 'Style', 'pushbutton', 'Position', [(figWidth/2)+10, 20, 150, 30], 'String', 'Proceed to Next Experiment', 'CallBack', ['MushraEvaluationCallbacks(''proceed'',' num2str(experimentNumber) ')']);
set(proceed, 'Enable', 'off');