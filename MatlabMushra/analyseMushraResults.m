%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%---------------------- analyseMushraResults.m ---------------------------
%/////////////////////////////////////////////////////////////////////////

function [meanResults, confidenceIntervals] = analyseMushraResults(path)

if nargin < 1
    path = '';
end 

% find all .mush files
cd(path) 
fileNames = dir('*.mush');
numFiles = length(fileNames);

% get results from first file and the number of experiments and samples per
% experiment.
load(fileNames(1).name, '-mat');
sizeResults = size(results.resultArray);
numExperiments = sizeResults(1);
samplesPerExperiment = sizeResults(2);

% initialise some variables and normalisation maths
masterResults = zeros(numExperiments, samplesPerExperiment, numFiles);
masterResults(:, :, 1) = results.resultArray;
normalisedResults = zeros(numExperiments, samplesPerExperiment, numFiles);
tempMin = min(min(results.resultArray));
tempRange = max(max(results.resultArray)) - tempMin;
tempScale = 100/tempRange;
normalisedResults(:, :, 1) = (results.resultArray - tempMin)*tempScale;

% load in the results and normalise
for k = 2:numFiles
    load(fileNames(k).name, '-mat');
    masterResults(:, :, k) = results.resultArray;
    tempMin = min(min(results.resultArray));
    tempRange = max(max(results.resultArray)) - tempMin;
    tempScale = 100/tempRange;
    normalisedResults(:, :, k) = (results.resultArray - tempMin)*tempScale;
end

% take the mean
meanResults = mean(normalisedResults, 3);

% initialise confidence varibles
confidenceLower = zeros(size(meanResults));
confidenceUpper = zeros(size(meanResults));

% calculate confidence
for k = 1:numExperiments
    for n = 1:samplesPerExperiment
        sampleResults = squeeze(normalisedResults(k, n, :));
        [why, what, confidenceInterval] = ttest(sampleResults);
        confidenceLower(k, n) = confidenceInterval(1);
        confidenceUpper(k, n) = confidenceInterval(2);
    end
end

% output confidence if need be
if nargout > 1
    confidenceIntervals = zeros(numExperiments, samplesPerExperiment, 2);
    confidenceIntervals(:, :, 1) = confidenceLower;
    confidenceIntervals(:, :, 2) = confidenceUpper;
end

% plot some stuff
for k = 1:numExperiments
    means = meanResults(k, :);
    figure('Name', ['Experiment ' num2str(k) ' Results'], 'NumberTitle', 'off');
    bar(means);
    if k==1
        title('Classical', 'FontSize', 12);
    elseif k==2
        title('Drum & Bass', 'FontSize', 12);
    elseif k==3
        title('Heavy Metal', 'FontSize', 12);
    elseif k==4
        title('Pop', 'FontSize', 12);
    else
        title('Singer-Songwriter', 'FontSize', 12);
    end
    xValues = 1:samplesPerExperiment;
    errorValues = means - confidenceLower(k, :);
    plottedXValues = xValues(errorValues>0.5);
    plottedErrorValues = errorValues(errorValues>0.5);
    plottedMeans = means(errorValues>0.5);
    hold on;
    errorbar(plottedXValues, plottedMeans, plottedErrorValues, '.r', 'MarkerSize', 0.1, 'LineWidth', 1);
    boundaries = axis;
    axis([boundaries(1:2) 0 120]);
    ylabel('Normalised Grade');
    xlabel('Track Number');
    set(gca,'FontSize',12)
end