%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%------------------------- MushraTraining.m ------------------------------
%/////////////////////////////////////////////////////////////////////////

function MushraTraining()
% GUI for the Mushra Training Phase

% get some more info
global samples;
sizeSamples = size(samples);
sizeSamples = sizeSamples(1:2);
numExperiments = sizeSamples(1);
samplesPerExperiment = sizeSamples(2);

% just to simplify some things
x = samplesPerExperiment;
y = numExperiments;

% set window dimensions
figWidth = 260 + (x-1)*70;
figHeight = (y+3)*50 - 10;

% get screen info and hence window positions
screenSize = get(0, 'ScreenSize');
screenWidth = screenSize(3);
screenHeight = screenSize(4);
windowX = screenWidth/2 - figWidth/2;
windowY = screenHeight/2 - figHeight/2;

% create window
windowColour = [102 139 139]/255;
fig = figure('Position', [windowX, windowY, figWidth, figHeight], 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'Mushra - Training Phase', 'NumberTitle', 'off', 'Resize', 'off', 'CloseRequestFcn', 'MushraTrainingCallbacks(''closeWindow'')', 'Color', windowColour);

% define some other colours
notPlayedColour = [172 23 31]/255;

% add title
uicontrol(fig, 'Style', 'text', 'Position', [25, figHeight-70, 200, 50], 'String', 'Training Phase', 'FontSize', 20, 'FontWeight', 'bold', 'BackgroundColor', windowColour)

% add sample number text
uicontrol(fig, 'Style', 'text', 'Position', [((figWidth-280)/2)+200, figHeight-40, 120, 20], 'String', 'Sample Number', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', windowColour);
for k = 1:samplesPerExperiment-1
    xPos = 260 + (k-1)*70;
    yPos = figHeight - 70;
    uicontrol(fig, 'Style', 'text', 'Position', [xPos, yPos, 50, 20], 'String', num2str(k), 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', windowColour);
end

% add experiment text and play reference buttons
global samplesPlayed buttonMatrix samplesOrder prevPlayed;
samplesPlayed = zeros(sizeSamples);
buttonMatrix = zeros(sizeSamples);
prevPlayed = [0, 0];
samplesOrder = zeros(sizeSamples);
samplesOrder(:, 1) = 1;
for experimentNumber = 1:numExperiments
    yPos = figHeight - (experimentNumber+2)*50 + 40;
    uicontrol(fig, 'Style', 'text', 'Position', [20, yPos, 100, 25], 'String', ['Experiment ' num2str(experimentNumber)], 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', windowColour);
    buttonMatrix(experimentNumber, 1) = uicontrol(fig, 'Style', 'pushbutton', 'Position', [140, yPos, 100, 30], 'String', 'Play Reference', 'BackgroundColor', notPlayedColour, 'CallBack', ['MushraTrainingCallbacks(''playSample'', ' num2str(experimentNumber) ', 1)']);
    samplesOrder(experimentNumber, 2:end) = randperm(samplesPerExperiment-1) + 1;
    % add play buttons
    for sampleNumber = 1:samplesPerExperiment-1
        xPos = 260 + (sampleNumber-1)*70;
        buttonMatrix(experimentNumber, sampleNumber+1) = uicontrol(fig, 'Style', 'pushbutton', 'Position', [xPos, yPos, 50, 30], 'String', 'Play', 'BackgroundColor', notPlayedColour, 'CallBack', ['MushraTrainingCallbacks(''playSample'',' num2str(experimentNumber) ',' num2str(sampleNumber+1) ')']);
    end
end

% make it pretty with some lines
canvas = axes('Units', 'pixels', 'Position', [0, 0, figWidth, figHeight], 'Visible', 'off', 'Xlim', [0, figWidth], 'Ylim', [0, figHeight]);
line(250:figWidth-10, figHeight - 10, 'Color', 'black', 'Parent', canvas);
line(250:figWidth-10, figHeight - 45, 'Color', 'black', 'Parent', canvas);
line(250, 70:figHeight-10, 'Color', 'black', 'Parent', canvas);
line(figWidth-10, 70:figHeight-10, 'Color', 'black', 'Parent', canvas);
line(10, 70:figHeight-70, 'Color', 'black', 'Parent', canvas);
line(130, 70:figHeight-70, 'Color', 'black', 'Parent', canvas);
for k = 1:numExperiments+1
    line(10:figWidth-10, 70 + (k-1)*50, 'Color', 'black', 'Parent', canvas);
end
for k = 1:samplesPerExperiment-1
    line(250 + k*70 , 70:figHeight-45, 'Color', 'black', 'Parent', canvas);
end

% add stop button
uicontrol(fig, 'Style', 'pushbutton', 'Position', [(figWidth/2)-160, 20, 150, 30], 'String', 'Stop Audio', 'CallBack', 'MushraTrainingCallbacks(''stopAudio'')');

% add proceed button
global proceed;
proceed = uicontrol(fig, 'Style', 'pushbutton', 'Position', [(figWidth/2)+10, 20, 150, 30], 'String', 'Proceed to Evaluation', 'CallBack', 'MushraTrainingCallbacks(''proceed'')');
set(proceed, 'Enable', 'off');