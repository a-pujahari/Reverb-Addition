clear vars;
%%Read Audio Files
[y1,Fs1] = audioread('Harp Edited.wav');
[y2,~] = audioread('Bass Edited.wav');
[y3,~] = audioread('Drums Combined.wav');
[y4,~] = audioread('Piano Edited.wav');
[y5,~] = audioread('Synth Combined.wav');

%% Apply appropriate scaling and preprocessing for partial loudness
Y.y1s = 0.3.*y1;
Y.y2s = 0.7.*y2;
Y.y3s = 0.6.*y3;
Y.y4s = 0.2.*y4;
Y.y5s = 0.5.*y5;

%% Declare Loudness meter and Reverberator
loudMtr = loudnessMeter('SampleRate', Fs1);
%reverb_long = reverberator('PreDelay',0.100,'DecayFactor',0.200,'WetDryMix',1,'HighFrequencyDamping',0.350);
%reverb_short = reverberator('PreDelay',0.010,'DecayFactor',0.800,'WetDryMix',1,'HighFrequencyDamping',0.450);

%% Calculate target loudness 

lmmn = loudMtr(Y.y1s+Y.y2s+Y.y3s+Y.y4s+Y.y5s);
lp1n = loudMtr(Y.y2s+Y.y5s+Y.y3s+Y.y4s);
lp2n = loudMtr(Y.y1s+Y.y5s+Y.y3s+Y.y4s);
lp3n = loudMtr(Y.y2s+Y.y5s+Y.y1s+Y.y4s);
lp4n = loudMtr(Y.y2s+Y.y5s+Y.y3s+Y.y1s);
lp5n = loudMtr(Y.y2s+Y.y1s+Y.y3s+Y.y4s);
lmmn(isinf(lmmn)) = 0;

b.lmm = mean(lmmn);
lp1 = mean(lp1n);
lp2 = mean(lp2n);
lp3 = mean(lp3n);
lp4 = mean(lp4n);
lp5 = mean(lp5n);

mp1 = b.lmm-lp1;
mp2 = b.lmm-lp2;
mp3 = b.lmm-lp3;
mp4 = b.lmm-lp4;
mp5 = b.lmm-lp5;
ml = (mp1+mp2+mp3+mp4+mp5)/5;

b.b1 = 10*log10(mp1/ml);
b.b2 = 10*log10(mp2/ml);
b.b3 = 10*log10(mp3/ml);
b.b4 = 10*log10(mp4/ml);
b.b5 = 10*log10(mp5/ml);

%% Prepare reverberated tracks

% Y.y1rl = reverb_long(Y.y1s); 
% Y.y2rl = reverb_long(Y.y2s);
% Y.y3rl = reverb_long(Y.y3s);
% Y.y4rl = reverb_long(Y.y4s);
% Y.y5rl = reverb_long(Y.y5s);
% 
% Y.y1rs = reverb_short(Y.y1s); 
% Y.y2rs = reverb_short(Y.y2s);
% Y.y3rs = reverb_short(Y.y3s);
% Y.y4rs = reverb_short(Y.y4s);
% Y.y5rs = reverb_short(Y.y5s);
% 
 save('Y.mat','Y');

save('b_corr.mat','b');
