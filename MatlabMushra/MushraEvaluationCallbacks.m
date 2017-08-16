%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%------------------- MushraEvaluationCallbacks.m -------------------------
%/////////////////////////////////////////////////////////////////////////

function MushraEvaluationCallbacks(varargin)
% Callback functions fot the Mushra Evaluation GUI
    functionName = varargin{1};
    feval(functionName, varargin{2:end});
end

% run when slider value is updated
function sliderMoved(sampleNumber)
    global sliderMatrix textMatrix;
    slider = sliderMatrix(sampleNumber);
    newValue = fix(get(slider, 'Value'));
    set(slider, 'Value', newValue);
    textBox = textMatrix(sampleNumber);
    set(textBox, 'String', num2str(newValue));
end

% plays samples corresponding to a given play button
function playSample(experimentNumber, sampleNumber)
    global audioToPlay;
    stop(audioToPlay);
    global samples samplesOrder;
    data = samples{experimentNumber, samplesOrder(sampleNumber), 1};
    fs = samples{experimentNumber, samplesOrder(sampleNumber), 2};
    audioToPlay = audioplayer(data, fs);
    play(audioToPlay);
    playedColour = [0 150 0]/255;
    playingColour = [30 144 255]/255;
    global samplesPlayed buttonMatrix sliderMatrix prevPlayed playRef;
    set(buttonMatrix(sampleNumber), 'BackgroundColor', playingColour);
    if samplesPlayed(sampleNumber) == 0
        samplesPlayed(sampleNumber) = 1;
    end
    set(sliderMatrix(sampleNumber), 'Enable', 'on');
    if (prevPlayed ~= sampleNumber) && (prevPlayed > 0)
        set(sliderMatrix(prevPlayed), 'enable', 'off');
        set(buttonMatrix(prevPlayed), 'BackgroundColor', playedColour);
    elseif prevPlayed == -1;
        set(playRef, 'BackgroundColor', playedColour);
    end
    prevPlayed = sampleNumber;
    global refPlayed proceed;
    if refPlayed && prod(samplesPlayed)
        set(proceed, 'Enable', 'on');
    end
end

% plays the reference sample
function playReference(experimentNumber)
    global audioToPlay;
    stop(audioToPlay);
    global samples;
    data = samples{experimentNumber, 1, 1};
    fs = samples{experimentNumber, 1, 2};
    audioToPlay = audioplayer(data, fs);
    play(audioToPlay);
    playedColour = [0 150 0]/255;
    playingColour = [30 144 255]/255;
    global refPlayed playRef buttonMatrix prevPlayed sliderMatrix;
    set(playRef, 'BackgroundColor', playingColour);
    if (prevPlayed ~= -1) && prevPlayed > 0
        set(buttonMatrix(prevPlayed), 'BackgroundColor', playedColour);
        set(sliderMatrix(prevPlayed), 'Enable', 'off');
    end  
    prevPlayed = -1;
    if refPlayed == 0
        refPlayed = 1;
    end
    global samplesPlayed proceed;
    if prod(samplesPlayed)
        set(proceed, 'Enable', 'on');
    end
end

% executed if the window is closed
function closeWindow()
    global audioToPlay;
    stop(audioToPlay);
    clear global;
    closereq;
end

% stop the audio
function stopAudio()
    global audioToPlay;
    stop(audioToPlay);
end

% proceed to next experiment
function proceed(experimentNumber)
    global sliderMatrix samples samplesOrder audioToPlay;
    sizeSamples = size(samples);
    numExperiments = sizeSamples(1);
    samplesPerExperiment = sizeSamples(2);
    experimentResults = zeros(1, samplesPerExperiment);
    for sampleNumber = 1:samplesPerExperiment
        experimentResults(samplesOrder(sampleNumber)) = get(sliderMatrix(sampleNumber), 'Value');
    end
    global urlString commentsOn;
    if sum(experimentResults==100) == 0
        warndlg('At Least One Sample Must Be Given A Score Of 100');
    else

        load(urlString, '-mat');
        results.resultArray(experimentNumber, :) = experimentResults;
        results.experimentNumber = results.experimentNumber + 1;
        results.evaluationTime(experimentNumber) = toc;
        save(urlString, 'results');
        stop(audioToPlay);
        closereq;
        if commentsOn
            MushraComments(experimentNumber, numExperiments);
        else
            if experimentNumber < numExperiments
                tic;
                MushraEvaluation(experimentNumber + 1);
            else
                msgbox('Thank You For Participating. Have A Marvelous Day!', 'Test Completed');
                clear global;
            end
        end
    end
end