%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%---------------------- LevelMatchCallbacks.m ----------------------------
%/////////////////////////////////////////////////////////////////////////

function LevelMatchCallbacks(varargin)
% Callback functions fot the Mushra Evaluation GUI
    functionName = varargin{1};
    feval(functionName, varargin{2:end});
end

function playSample(experimentNumber, sampleNumber)
    global samples audioToPlay editMatrix clipMatrix;
    stop(audioToPlay);
    gain = 10^(str2double(get(editMatrix(experimentNumber, sampleNumber), 'String'))/20);
    audioSamples = samples{experimentNumber, sampleNumber, 1}*gain;
    if max(abs(audioSamples)) > 1
        set(clipMatrix(experimentNumber, sampleNumber), 'BackgroundColor', 'red', 'String', 'Clip');
    else
        set(clipMatrix(experimentNumber, sampleNumber), 'BackgroundColor', 'green', 'String', 'Ok');
    end
    audioToPlay = audioplayer(audioSamples, samples{experimentNumber, sampleNumber, 2});
    play(audioToPlay);
end

function closeWindow()
    global audioToPlay;
    stop(audioToPlay);
    clear global;
    closereq;
end

function finalise()
    global audioToPlay editMatrix sampleStrings samples;
    stop(audioToPlay);
    samplesSize = size(sampleStrings);
    numExperiments = samplesSize(1);
    samplesPerExperiment = samplesSize(2);
    for experimentNumber = 1:numExperiments;
        for sampleNumber = 1:samplesPerExperiment;
            if str2double(get(editMatrix(experimentNumber, sampleNumber), 'String')) ~= 0
                audioSamples = samples{experimentNumber, sampleNumber, 1};
                fs = samples{experimentNumber, sampleNumber, 2};
                gain = 10^(str2double(get(editMatrix(experimentNumber, sampleNumber), 'String'))/20);
                wavwrite(audioSamples*gain, fs, sampleStrings{experimentNumber, sampleNumber});
            end
        end
    end
    clear global;
    closereq;
end