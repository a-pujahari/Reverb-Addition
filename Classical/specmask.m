%% Spectral Masking Minimization
clear vars

%% Load stored files
load('Y.mat','Y');

%% Convert Stereo to Mono

y1sm = mean(Y.y1s,2);
y2sm = mean(Y.y2s,2);
y3sm = mean(Y.y3s,2);
y4sm = mean(Y.y4s,2);
y5sm = mean(Y.y5s,2);

Y1rlm = mean(Y.y1rl,2);
Y2rlm = mean(Y.y2rl,2);
Y3rlm = mean(Y.y3rl,2);
Y4rlm = mean(Y.y4rl,2);
Y5rlm = mean(Y.y5rl,2);

Y1rsm = mean(Y.y1rs,2);
Y2rsm = mean(Y.y2rs,2);
Y3rsm = mean(Y.y3rs,2);
Y4rsm = mean(Y.y4rs,2);
Y5rsm = mean(Y.y5rs,2);

%% Calculate power spectral density

psd1 = (abs(fft(y1sm))).^2;
psd2 = (abs(fft(y2sm))).^2;
psd3 = (abs(fft(y3sm))).^2;
psd4 = (abs(fft(y4sm))).^2;
psd5 = (abs(fft(y5sm))).^2;

psdrl1 = (abs(fft(Y1rlm))).^2;
psdrl2 = (abs(fft(Y2rlm))).^2;
psdrl3 = (abs(fft(Y3rlm))).^2;
psdrl4 = (abs(fft(Y4rlm))).^2;
psdrl5 = (abs(fft(Y5rlm))).^2;

psdrs1 = (abs(fft(Y1rsm))).^2;
psdrs2 = (abs(fft(Y2rsm))).^2;
psdrs3 = (abs(fft(Y3rsm))).^2;
psdrs4 = (abs(fft(Y4rsm))).^2;
psdrs5 = (abs(fft(Y5rsm))).^2;

%% Calculate track priority

SMl1 = (psdrl1 - psd1);
SMl2 = (psdrl2 - psd2);
SMl3 = (psdrl3 - psd3);
SMl4 = (psdrl4 - psd4);
SMl5 = (psdrl5 - psd5);

SMs1 = (psdrs1 - psd1);
SMs2 = (psdrs2 - psd2);
SMs3 = (psdrs3 - psd3);
SMs4 = (psdrs4 - psd4);
SMs5 = (psdrs5 - psd5);

SMl1(SMl1>0)=1;SMl1(SMl1<0)=0;
SMl2(SMl2>0)=1;SMl2(SMl2<0)=0;
SMl3(SMl3>0)=1;SMl3(SMl3<0)=0;
SMl4(SMl4>0)=1;SMl4(SMl4<0)=0;
SMl5(SMl5>0)=1;SMl5(SMl5<0)=0;

SMs1(SMs1>0)=1;SMs1(SMs1<0)=0;
SMs2(SMs2>0)=1;SMs2(SMs2<0)=0;
SMs3(SMs3>0)=1;SMs3(SMs3<0)=0;
SMs4(SMs4>0)=1;SMs4(SMs4<0)=0;
SMs5(SMs5>0)=1;SMs5(SMs5<0)=0;

SMlong = [sum(SMl1); sum(SMl2); sum(SMl3); sum(SMl4); sum(SMl5)];
SMshort = [sum(SMs1); sum(SMs2); sum(SMs3); sum(SMs4); sum(SMs5)];

Glong = SMlong./length(SMl1);
Gshort = SMshort./length(SMs1);

G(1) = 1 - Glong(1);
G(2) = 1 - Glong(2);
G(3) = 1 - Glong(3);
G(4) = 1 - Glong(4);
G(5) = 1 - Glong(5);

G(6) = 1 - Gshort(1);
G(7) = 1 - Gshort(2);
G(8) = 1 - Gshort(3);
G(9) = 1 - Gshort(4);
G(10) = 1 - Gshort(5);
% [a,Ilong] = sort(SMlong);
% [b,Ishort] = sort(SMshort);
% 
% %% Calculate gaussian fader gain values
% 
% mul = 0.5*(Ilong(1)-1);
% 
% x1 = 0.5*(Ilong(1)-1); G(1) = 6.266*0.8*normpdf(x1,mul,2.5);
% x2 = 0.5*(Ilong(2)-1); G(2) = 6.266*0.8*normpdf(x2,mul,2.5);
% x3 = 0.5*(Ilong(3)-1); G(3) = 6.266*0.8*normpdf(x3,mul,2.5);
% x4 = 0.5*(Ilong(4)-1); G(4) = 6.266*0.8*normpdf(x4,mul,2.5);
% x5 = 0.5*(Ilong(5)-1); G(5) = 6.266*0.8*normpdf(x5,mul,2.5);
% 
% mus = 0.5*(Ishort(1)-1);
% 
% x1s = 0.5*(Ishort(1)-1); G(6) = 6.266*0.8*normpdf(x1s,mus,2.5);
% x2s = 0.5*(Ishort(2)-1); G(7) = 6.266*0.8*normpdf(x2s,mus,2.5);
% x3s = 0.5*(Ishort(3)-1); G(8) = 6.266*0.8*normpdf(x3s,mus,2.5);
% x4s = 0.5*(Ishort(4)-1); G(9) = 6.266*0.8*normpdf(x4s,mus,2.5);
% x5s = 0.5*(Ishort(5)-1); G(10) = 6.266*0.8*normpdf(x5s,mus,2.5);

save('G_specmask_alt.mat','G');