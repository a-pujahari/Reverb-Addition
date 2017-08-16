%% Mathematics of Mixing Optimization

f = @OptimProc;
G0=zeros(10,1);
lb=zeros(10,1);
ub=ones(10,1);

G = lsqnonlin(f,G0,lb,ub);
save('Glsqnonlin.mat','G');

