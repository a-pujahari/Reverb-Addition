%% Mathematics of Mixing Optimization
clear vars;

f = @MinConTest_ult;
G0=zeros(10,1);
lb=zeros(10,1);
ub=ones(10,1);

G = fmincon(f,G0,[],[],[],[],lb,ub);
save('Gmincon_final.mat','G');

