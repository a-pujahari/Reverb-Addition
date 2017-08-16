%%%%Prepare files for listening tests
clear all
%% Read Audio Files

[y1,Fs1] = audioread('Backing Vox Edited.wav');
[y2,~] = audioread('Bass Edited.wav');
[y3,~] = audioread('Drums Combined.wav');
[y4,~] = audioread('ElecGtr Edited.wav');
[y5,~] = audioread('Lead Vox Edited.wav');

%% Apply appropriate scaling

Y.y1s = 0.8.*y1;
Y.y2s = 0.9.*y2;
Y.y3s = 0.8.*y3;
Y.y4s = 0.9.*y4;
Y.y5s = 0.8.*y5;
%% Load Reverberation objects

load('reverb_long.mat'); load('reverb_short.mat');

%% Creating files through Additive Reverb implementation

for i=1:5
    if i == 1
        clear G
        load('Gmincon_final.mat','G');
        y1rev = Y.y1s + reverb_long(G(1).*Y.y1s) + reverb_short(G(6).*Y.y1s);
        y2rev = Y.y2s + reverb_long(G(2).*Y.y2s) + reverb_short(G(7).*Y.y2s);
        y3rev = Y.y3s + reverb_long(G(3).*Y.y3s) + reverb_short(G(8).*Y.y3s);
        y4rev = Y.y4s + reverb_long(G(4).*Y.y4s) + reverb_short(G(9).*Y.y4s);
        y5rev = Y.y5s + reverb_long(G(5).*Y.y5s) + reverb_short(G(10).*Y.y5s);
        
        file1 = y1rev+y2rev+y3rev+y4rev+y5rev;
        x1 = max(max(abs(file1)));
        file1 = file1/x1;
        audiowrite('Pop_math.wav',file1,44100);
    elseif i == 2
        clear G
        load('G_specmask_alt.mat','G');
        y1rev = Y.y1s + reverb_long(G(1).*Y.y1s) + reverb_short(G(6).*Y.y1s);
        y2rev = Y.y2s + reverb_long(G(2).*Y.y2s) + reverb_short(G(7).*Y.y2s);
        y3rev = Y.y3s + reverb_long(G(3).*Y.y3s) + reverb_short(G(8).*Y.y3s);
        y4rev = Y.y4s + reverb_long(G(4).*Y.y4s) + reverb_short(G(9).*Y.y4s);
        y5rev = Y.y5s + reverb_long(G(5).*Y.y5s) + reverb_short(G(10).*Y.y5s);
        
        file2 = y1rev+y2rev+y3rev+y4rev+y5rev;
        x2 = max(max(abs(file2)));
        file2 = file2/x2;
        audiowrite('Pop_spec.wav',file2,44100);
    elseif i == 3
        clear G
        load('G_pro_prod.mat','G');
        y1rev = Y.y1s + reverb_long(G(1).*Y.y1s) + reverb_short(G(6).*Y.y1s);
        y2rev = Y.y2s + reverb_long(G(2).*Y.y2s) + reverb_short(G(7).*Y.y2s);
        y3rev = Y.y3s + reverb_long(G(3).*Y.y3s) + reverb_short(G(8).*Y.y3s);
        y4rev = Y.y4s + reverb_long(G(4).*Y.y4s) + reverb_short(G(9).*Y.y4s);
        y5rev = Y.y5s + reverb_long(G(5).*Y.y5s) + reverb_short(G(10).*Y.y5s);
        
        file3 = y1rev+y2rev+y3rev+y4rev+y5rev;
        x3 = max(max(abs(file3)));
        file3 = file3/x3;
        audiowrite('Pop_prod.wav',file3,44100);
    elseif i == 4
        clear G                      
        file4 = Y.y1s+Y.y2s+Y.y3s+Y.y4s+Y.y5s;
        x4 = max(max(abs(file4)));
        file4 = file4/x4;
        audiowrite('Pop_unrev.wav',file4,44100);
    elseif i == 5
        LPF=dsp.LowpassFilter('PassbandFrequency',1000,'StopbandFrequency',1500);
        file5 = LPF(file4);
        audiowrite('Pop_lpf.wav',file5,44100);
    end
end