%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%------------------- CreateMushraDistributable.m -------------------------
%/////////////////////////////////////////////////////////////////////////

function CreateMushraDistributable(varargin)
% creates a distribution folder with all samples included and a launch
% script and continue script

% deal with optional arguments
if length(varargin) > 1
    flags = varargin{2:end};
else
    flags = 0;
end

% test subject comments on or off
commentsOn = 0;
if strmatch('comments', flags, 'exact')
    commentsOn = 1;
end

% open the config file
config = varargin{1};
if ~exist(config, 'file')
    errordlg('The configuration file you have requested does not exist.');
    return;
end
file = fopen(config, 'r');

[configFilePath configFileName] = fileparts(config);

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

% check that all samples are valid audio files
for experimentNumber = 1:numExperiments
    for sampleNumber = 1:samplesPerExperiment
        if strcmp(wavfinfo(sampleStrings{experimentNumber, sampleNumber}), '')
            errordlg(['Sample Number ' num2str(sampleNumber) ' In Experiment Number ' num2str(experimentNumber) ' Is Not A Valid Wave File']);
            return;
        end
    end
end

% warning if there are too many samples per experiment
if samplesPerExperiment > 14
    response = questdlg('It is recommended that there should be no more than 15 samples per experiment (including known and hidden reference). Do you still wish to create the test?', 'Too many samples', 'Yes', 'No', 'No');
    if isequal(response, 'No')
        return;
    end
end

% create distribution folders
if ~isequal(configFilePath, '')
    configFilePath = [configFilePath '\'];
end
mkdir([configFilePath configFileName '_Distributable']);
mkdir([configFilePath configFileName '_Distributable\Samples']);

% copy in samples
uniqueSamples = unique(sampleStrings);
numUniqueSamples = length(uniqueSamples);
for sampleNumber = 1:numUniqueSamples
    copyfile(uniqueSamples{sampleNumber}, [configFilePath configFileName '_Distributable\Samples\']);
end

% copy in Mushra files
copyfile('Mushra.m', [configFilePath configFileName '_Distributable\']);
copyfile('MushraComments.m', [configFilePath configFileName '_Distributable\']);
copyfile('MushraCommentsCallbacks.m', [configFilePath configFileName '_Distributable\']);
copyfile('MushraEvaluation.m', [configFilePath configFileName '_Distributable\']);
copyfile('MushraEvaluationCallbacks.m', [configFilePath configFileName '_Distributable\']);
copyfile('MushraTraining.m', [configFilePath configFileName '_Distributable\']);
copyfile('MushraTrainingCallbacks.m', [configFilePath configFileName '_Distributable\']);
copyfile('MushraResult.m', [configFilePath configFileName '_Distributable\']);

% create new config file
newConfigFile = fopen([configFilePath configFileName '_Distributable\' configFileName '.txt'], 'w');
for experimentNumber = 1:numExperiments
    for sampleNumber = 1:samplesPerExperiment
        [sampleFilePath sampleFileName sampleFileExtention] = fileparts(sampleStrings{experimentNumber, sampleNumber});
        fprintf(newConfigFile, './Samples/%s\n', [sampleFileName sampleFileExtention]);
    end
    fprintf(newConfigFile, '\n');
end
fclose(newConfigFile);

% create launch script
launchScript = fopen([configFilePath configFileName '_Distributable\begin.m'], 'w');
if commentsOn
    fprintf(launchScript, 'Mushra(''%s.txt'', ''comments'')', configFileName);
else
    fprintf(launchScript, 'Mushra(''%s.txt'')', configFileName);
end
fclose(launchScript);

% create continue script
continueScript = fopen([configFilePath configFileName '_Distributable\continue.m'], 'w');
if commentsOn
    fprintf(continueScript, 'Mushra(''%s.txt'', ''continue'', ''comments'')', configFileName);
else
    fprintf(continueScript, 'Mushra(''%s.txt'', ''continue'')', configFileName);
end
fclose(continueScript);