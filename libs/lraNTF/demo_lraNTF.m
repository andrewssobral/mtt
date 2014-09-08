clear;clc;
I=[30 50 40 60];
R=10;
N=numel(I);

for n=1:N
    A{n}=rand(I(n),R);
end
lambda=rand(R,1);
Y=ktensor(lambda,A);

Y=double(Y);
Ynoise=Y+(1e-3)*randn(I);

%% Run CP-HALS without nonnegativity
cp_hals_opts=struct('NumOfComp',R,'maxiter',200,'nonnegativity',zeros(N,1));
tic;
Ycap=CP_HALS(Ynoise,cp_hals_opts);
toc
fprintf('Unconstrained CP-HALS: Residual %f.\n\n',fitness(Y,Ycap));

%% Run CP-HALS with nonnegativity
cp_hals_opts=struct('NumOfComp',R,'maxiter',200,'nonnegativity',ones(N,1));
tic;
Ycap=CP_HALS(Ynoise,cp_hals_opts);
toc
fprintf('Constrained CP-HALS: Residual %f.\n\n',fitness(Y,Ycap));


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Nonnegative Tensor Factionzation (Nonnegative CPD) using low-rank approximation -- LRA
lraNTF_opts=struct('NumOfComp',R,'CPalg','CP_HALS_opts.mat','lra_rank',R+1,'maxiter',200,'nlssolver','apg','initmode','cp','lra',true);
tic;
Ycap=lraNTF(Ynoise,lraNTF_opts);
toc
fprintf('[LRA mode] lraNTF: Residual %f.\n\n',fitness(Y,Ycap));

%% Nonnegative Tensor Factionzation (Nonnegative CPD) using low-rank approximation  -- without LRA
lraNTF_opts=struct('NumOfComp',R,'maxiter',200,'maxiniter',20,'nlssolver','apg','initmode','random','lra',false);
tic;
Ycap=lraNTF(Ynoise,lraNTF_opts);
toc
fprintf('lraNTF: Residual %f.\n\n',fitness(Y,Ycap));