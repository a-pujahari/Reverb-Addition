%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%-------------------------- LevelMatch.m ---------------------------------
%/////////////////////////////////////////////////////////////////////////

function LevelMatch(config)

% open the config file
if ~exist(config, 'file')
    errordlg('The configuration file you have requested does not exist.');
    clear global;
    return;
end
file = fopen(config, 'r');

% set some initial values
lines = {};
lineNumber = 1;

% read first line of the file
currentLine = fgetl(file);

% read the rest of the lines and create a cell array of them
while ~isequal(currentLine, -1)
    lines{lineNumber} = currentLine;
    lineNumber = lineNumber + 1;
    currentLine = fgetl(file);
end

% close the file
fclose(file);

% remove empty lines from the end
while prod(double(isspace(lines{end})))
    lines = {lines{1:end-1}};
end

% determine number of experiments and samples per experiment
numLines = length(lines);
samplesPerExperiment = 0;
numExperiments = 0;
prevLineBlank = 1;
prevSamplesPerExperiment = 0;
for lineNumber = 1:numLines
    if ~prevLineBlank && ~prod(double(isspace(lines{lineNumber})))
        samplesPerExperiment = samplesPerExperiment + 1;
    end
    if prevLineBlank && ~prod(double(isspace(lines{lineNumber})))
        numExperiments = numExperiments + 1;
        samplesPerExperiment = samplesPerExperiment + 1;
        prevLineBlank = 0;
    end
    if ~prevLineBlank && prod(double(isspace(lines{lineNumber})))
        if (prevSamplesPerExperiment > 0) && (prevSamplesPerExperiment ~= samplesPerExperiment)
            errordlg('All Experiments Must Contain The Same Number Of Samples');
            return;
        end
        prevLineBlank = 1;
        prevSamplesPerExperiment = samplesPerExperiment;
        samplesPerExperiment = 0;
    end
    if (lineNumber == numLines) && (prevSamplesPerExperiment ~= samplesPerExperiment) && (prevSamplesPerExperiment > 0)
        errordlg('All Experiments Must Contain The Same Number Of Samples');
        return;
    end
end

% make samples strings array
global sampleStrings;
sampleStrings = cell(numExperiments, samplesPerExperiment);
currentExperiment = 1;
currentSample = 1;
for lineNumber = 1:numLines
    if ~prod(double(isspace(lines{lineNumber})))
        sampleStrings{currentExperiment, currentSample} = lines{lineNumber};
        if currentSample == samplesPerExperiment
            currentSample = 1;
            currentExperiment = currentExperiment + 1;
        else
            currentSample = currentSample + 1;
        end
    end
end

% check that all samples are valid audio files then read into samples array
global samples;
samples = cell(numExperiments, samplesPerExperiment, 2);
for experimentNumber = 1:numExperiments
    for sampleNumber = 1:samplesPerExperiment
        if strcmp(wavfinfo(sampleStrings{experimentNumber, sampleNumber}), '')
            errordlg(['Sample Number ' num2str(sampleNumber) ' In Experiment Number ' num2str(experimentNumber) ' Is Not A Valid Wave File']);
            return
        else
            [samples{experimentNumber, sampleNumber, 1}, samples{experimentNumber, sampleNumber, 2}] = wavread(sampleStrings{experimentNumber, sampleNumber});
        end
    end
end

% calculate window size
figWidth = 20 + 70*samplesPerExperiment;
figHeight = 100 + 150*numExperiments;

% get screen info and hence window positions
screenSize = get(0, 'ScreenSize');
screenWidth = screenSize(3);
screenHeight = screenSize(4);
windowX = screenWidth/2 - figWidth/2;
windowY = screenHeight/2 - figHeight/2;

% the figure lives
windowColour = [102 139 139]/255;
fig = figure('Position', [windowX, windowY, figWidth, figHeight], 'ToolBar', 'none', 'MenuBar', 'none', 'Name', 'Mushra - Level Match', 'NumberTitle', 'off', 'Resize', 'off', 'Color', windowColour, 'CloseRequestFcn', 'LevelMatchCallbacks(''closeWindow'')');

% populate the window
global editMatrix clipMatrix buttonMatrix;
editMatrix = zeros(numExperiments, samplesPerExperiment);
clipMatrix = zeros(numExperiments, samplesPerExperiment);
buttonMatrix = zeros(numExperiments, samplesPerExperiment);
alreadyIncluded = cell(0);
inclusionCounter = 0;
for experimentNumber = 1:numExperiments
    vertPos = figHeight -  20 - 150*(experimentNumber-1);
    for sampleNumber = 1:samplesPerExperiment
        horiPos = 20 + (sampleNumber-1)*70;
        uicontrol(fig, 'Style', 'text', 'Position', [horiPos, vertPos-40, 50, 20], 'FontSize', 12', 'FontWeight', 'bold', 'BackgroundColor', windowColour, 'String', sampleNumber+(experimentNumber-1)*samplesPerExperiment);
        editMatrix(experimentNumber, sampleNumber) = uicontrol(fig, 'Style', 'edit', 'Position', [horiPos, vertPos-70, 50, 30], 'FontSize', 12', 'BackgroundColor', 'white', 'String', 0);
        clipMatrix(experimentNumber, sampleNumber) = uicontrol(fig, 'Style', 'text', 'Position', [horiPos, vertPos-100, 50, 20], 'FontSize', 12', 'String', 'Ok', 'BackgroundColor', 'green');
        buttonMatrix(experimentNumber, sampleNumber) = uicontrol(fig, 'Style', 'pushbutton', 'Position', [horiPos, vertPos-140, 50, 30], 'String', 'Play', 'Callback', ['LevelMatchCallbacks(''playSample'',' num2str(experimentNumber) ',' num2str(sampleNumber) ')']);
        
        if sum(sum(ismember(alreadyIncluded, sampleStrings{experimentNumber, sampleNumber})))
            set(editMatrix(experimentNumber, sampleNumber), 'Enable', 'off');
            set(buttonMatrix(experimentNumber, sampleNumber), 'Enable', 'off');
        else
            inclusionCounter = inclusionCounter + 1;
            alreadyIncluded{inclusionCounter} = sampleStrings{experimentNumber, sampleNumber};
        end
    end
end

uicontrol(fig, 'Style', 'pushbutton', 'Position', [figWidth/2 - 50, 20, 100, 30], 'String', 'I Am Done!', 'Callback', 'LevelMatchCallbacks(''finalise'')');

% audio to play
global audioToPlay;
audioToPlay = audioplayer(1, 44100);