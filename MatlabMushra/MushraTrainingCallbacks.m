%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%-------------------- MushraTrainingCallbacks.m --------------------------
%/////////////////////////////////////////////////////////////////////////


function MushraTrainingCallbacks(varargin)
% Callback functions fot the Mushra Training GUI
    functionName = varargin{1};
    feval(functionName, varargin{2:end});
end

% plays samples corresponding to a given play button
function playSample(experimentNumber, sampleNumber)
    global audioToPlay;
    stop(audioToPlay);
    global samples samplesOrder prevPlayed;
    data = samples{experimentNumber, samplesOrder(experimentNumber, sampleNumber), 1};
    fs = samples{experimentNumber, samplesOrder(experimentNumber, sampleNumber), 2};
    audioToPlay = audioplayer(data, fs);
    play(audioToPlay);
    playedColour = [0 150 0]/255;
    playingColour = [30 144 255]/255;
    global samplesPlayed buttonMatrix;
    set(buttonMatrix(experimentNumber, sampleNumber), 'BackgroundColor', playingColour);
    if samplesPlayed(experimentNumber, sampleNumber) == 0
        samplesPlayed(experimentNumber, sampleNumber) = 1;
    end
    global proceed;
    if prod(prod(samplesPlayed))

        set(proceed, 'Enable', 'On');
    end
    if (~isequal(prevPlayed, [0, 0])) && (~isequal(prevPlayed, [experimentNumber, sampleNumber]))
        set(buttonMatrix(prevPlayed(1), prevPlayed(2)), 'BackgroundColor', playedColour);
    end
    prevPlayed = [experimentNumber, sampleNumber];
end

% stops all audio
function stopAudio()
    global audioToPlay;
    stop(audioToPlay);
end

% training is done, proceed to evaluation
function proceed()
    global audioToPlay;
    stop(audioToPlay);
    global urlString;
    load(urlString, '-mat');
    results.trainingTime = results.trainingTime + toc;
    save(urlString, 'results');
    closereq;
    tic;
    MushraEvaluation(results.experimentNumber);
end

% executed if the window is closed
function closeWindow()
    global audioToPlay;
    stop(audioToPlay);
    clear global;
    closereq;
end