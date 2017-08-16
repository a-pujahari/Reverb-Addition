%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%-------------------- MushraCommentsCallbacks.m --------------------------
%/////////////////////////////////////////////////////////////////////////

function MushraCommentsCallbacks(varargin)
% Callback functions fot the Mushra Evaluation GUI
    functionName = varargin{1};
    feval(functionName, varargin{2:end});
end

function submit(experimentNumber, numExperiments)
global urlString commentBox;
load(urlString, '-mat');
results.comments{experimentNumber} = get(commentBox, 'String');
save(urlString, 'results');
closereq;
if experimentNumber < numExperiments
    tic;
    MushraEvaluation(experimentNumber + 1);
else
    msgbox('Thank You For Participating. Have A Marvelous Day!', 'Test Completed');
    clear global;
end
end

function closeWindow()
clear global;
closereq;
end
