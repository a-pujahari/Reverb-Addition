%% Mathematics of Mixing Optimization
clear vars;
f = @MinConTest_ult;
G0=zeros(10,1);
lb=zeros(10,1);
ub=ones(10,1);


%loudMtr = loudnessMeter('SampleRate', 44100);
% reverb_long = reverberator('PreDelay',0.100,'DecayFactor',0.200,'WetDryMix',1,'HighFrequencyDamping',0.350);
% reverb_short = reverberator('PreDelay',0.010,'DecayFactor',0.800,'WetDryMix',1,'HighFrequencyDamping',0.450);

G = fmincon(f,G0,[],[],[],[],lb,ub);
save('Gmincon_final.mat','G');

