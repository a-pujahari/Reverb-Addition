%/////////////////////////////////////////////////////////////////////////
%------------------------ MUSHRA VERSION 0.4 -----------------------------
%------------------------- MushraResult.m --------------------------------
%/////////////////////////////////////////////////////////////////////////

classdef MushraResult
    % a class to contain the results from a Mushra test
    
    properties 
        resultArray
        experimentNumber
        trainingTime
        evaluationTime
        comments
        configFile
    end
    
    methods
        function obj = MushraResult(numExperiments, samplesPerExperiment)
            obj.resultArray = zeros(numExperiments, samplesPerExperiment);
            obj.experimentNumber = 0;
            obj.trainingTime = 0;
            obj.evaluationTime = zeros(1, numExperiments);
            obj.comments = cell(1, numExperiments);
            obj.configFile = '';
        end
    end
end