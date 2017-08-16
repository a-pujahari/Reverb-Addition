%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%---------------------------- Mushra.m -----------------------------------
%/////////////////////////////////////////////////////////////////////////

function Mushra(varargin)
% Start a Mushra test

% deal with optional arguments
if length(varargin) > 1
    flags = varargin{2:end};
else
    flags = 0;
end

% test subject comments on or off
global commentsOn
if strmatch('comments', flags, 'exact')
    commentsOn = 1;
else
    commentsOn = 0;
end

% continue from previous save file or start afresh
if strmatch('continue', flags, 'exact')
    continueOn = 1;
else
    continueOn = 0;
end

% open the config file
config = varargin{1};
if ~exist(config, 'file')
    errordlg('The configuration file you have requested does not exist.');
    clear global;
    return;
end
file = fopen(config, 'r');

[configFilePath configFileName configFileExtension] = fileparts(config);

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

% check that all samples are valid audio files then read into samples array
global samples;
samples = cell(numExperiments, samplesPerExperiment, 2);
for experimentNumber = 1:numExperiments
    for sampleNumber = 1:samplesPerExperiment
        if strcmp(audioinfo(sampleStrings{experimentNumber, sampleNumber}), '')
            errordlg(['Sample Number ' num2str(sampleNumber) ' In Experiment Number ' num2str(experimentNumber) ' Is Not A Valid Wave File']);
            return
        else
            [samples{experimentNumber, sampleNumber, 1}, samples{experimentNumber, sampleNumber, 2}] = audioread(sampleStrings{experimentNumber, sampleNumber});
        end
    end
end

% warning if there are too many samples per experiment
if samplesPerExperiment > 14
    response = questdlg('It is recommended that there should be no more than 15 samples per experiment (including known and hidden reference). Do you still wish to continue with the test?', 'Too many samples', 'Yes', 'No', 'No');
    if isequal(response, 'No')
        return;
    end
end

% object for playing audio
global audioToPlay;
audioToPlay = audioplayer(1, 44100);

% save file stuff
if ~isequal(configFilePath, '')
    configFilePath = [configFilePath '\'];
end

% ask subject for a save file location
global urlString;
if continueOn
    [resultsFileName, resultsFilePath] = uigetfile([configFilePath '*.mush'], 'Name Results File');
else
    [resultsFileName, resultsFilePath] = uiputfile([configFilePath 'MyResults.mush'], 'Name Results File');
end
urlString = [resultsFilePath resultsFileName];

% save results file and begin the test
if resultsFileName == 0
    clear global;
    return;
else
    if continueOn
        load(urlString, '-mat');
        if ~isequal(results.configFile, [configFileName configFileExtension]) || ~isequal(size(results.resultArray), [numExperiments, samplesPerExperiment])
            errordlg('The results file you wish to load was not created with this configuration file.');
            clear global;
            return;
        end
    else
        results = MushraResult(numExperiments, samplesPerExperiment);
        results.experimentNumber = 1;
        results.configFile = [configFileName configFileExtension];
        save(urlString, 'results');
    end
end

tic;
MushraTraining();
