function [e] = MinConTest_ult(G)

%% Load workspace data
load('Y.mat','Y');load('b_corr.mat','b');
load('loudMtr.mat');
load('reverb_long.mat'); load('reverb_short.mat');

%% Define additive reverb structure mathematically

y1rev = Y.y1s + reverb_long(G(1).*Y.y1s) + reverb_short(G(6).*Y.y1s);
y2rev = Y.y2s + reverb_long(G(2).*Y.y2s) + reverb_short(G(7).*Y.y2s);
y3rev = Y.y3s + reverb_long(G(3).*Y.y3s) + reverb_short(G(8).*Y.y3s);
y4rev = Y.y4s + reverb_long(G(4).*Y.y4s) + reverb_short(G(9).*Y.y4s);
y5rev = Y.y5s + reverb_long(G(5).*Y.y5s) + reverb_short(G(10).*Y.y5s);

%% Calculate Loudness

lmrevn = loudMtr(y1rev+y2rev+y3rev+y4rev+y5rev);
lp1revn = loudMtr(y2rev+y5rev+y3rev+y4rev);
lp2revn = loudMtr(y1rev+y5rev+y3rev+y4rev);
lp3revn = loudMtr(y2rev+y5rev+y1rev+y4rev);
lp4revn = loudMtr(y2rev+y5rev+y3rev+y1rev);
lp5revn = loudMtr(y2rev+y1rev+y3rev+y4rev);
lmrevn(isinf(lmrevn)) = 0;

lmrev = mean(lmrevn);
lp1rev = mean(lp1revn);
lp2rev = mean(lp2revn);
lp3rev = mean(lp3revn);
lp4rev = mean(lp4revn);
lp5rev = mean(lp5revn);

mp1r=lmrev-lp1rev;
mp2r=lmrev-lp2rev;
mp3r=lmrev-lp3rev;
mp4r=lmrev-lp4rev;
mp5r=lmrev-lp5rev;
mlr=(mp1r+mp2r+mp3r+mp4r+mp5r)/5;

b1c=10*log10(mp1r/mlr);
b2c=10*log10(mp2r/mlr);
b3c=10*log10(mp3r/mlr);
b4c=10*log10(mp4r/mlr);
b5c=10*log10(mp5r/mlr);

%% Calculate error

e = (b.b1-b1c)^2+(b.b2-b2c)^2+(b.b3-b3c)^2+(b.b4-b4c)^2+(b.b5-b5c)^2+(lmrev-2-b.lmm)^2+exp(-(G(1)+G(2)+G(3)+G(4)+G(5)))+exp(-(G(6)+G(7)+G(8)+G(9)+G(10)))+abs(1-G(1))+abs(1-G(2))+abs(1-G(3))+abs(1-G(4))+abs(1-G(5))+abs(1-G(6))+abs(1-G(7))+abs(1-G(8))+abs(1-G(9))+abs(1-G(10));

% e(1) = (b1-b1c);
% e(2) = (b2-b2c);
% e(3) = (b3-b3c);
% e(4) = (b4-b4c);
% e(5) = (b5-b5c);
% e(6) = (lmrev-2-lmm);
% e(7) = exp(-(G(1)+G(2)+G(3)+G(4)+G(5)));
% e(8) = exp(-(G(6)+G(7)+G(8)+G(9)+G(10)));
% e(9) = abs(1-G(1))+abs(1-G(2))+abs(1-G(3))+abs(1-G(4))+abs(1-G(5));
% e(10) = abs(1-G(6))+abs(1-G(7))+abs(1-G(8))+abs(1-G(9))+abs(1-G(10));
end
