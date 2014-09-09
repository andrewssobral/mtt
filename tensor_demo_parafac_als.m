%% TENSOR PARAFAC (ALS solver)
close all; clear all; clc;

%% LIBRARIES
addpath('libs/poblano_toolbox_1.1');
addpath('libs/tensor_toolbox_2.5');
addpath('libs/nway331');
addpath('libs/parafac2');

%% LOAD DATASET
load('dataset/trafficdb/traffic_patches.mat');
A = double(imgdb{100});
T = tensor(A);

%% PARAFAC/CP DECOMPOSITION via Alternating Least-Squares (ALS)
n = size(A);
r = 10;

% Find the closest length - r ktensor ...
%   cp_als         - Compute a CP decomposition of any type of tensor.
%   cp_apr         - Compute nonnegative CP with alternating Poisson regression.
%   cp_nmu         - Compute nonnegative CP with multiplicative updates.
%   cp_opt         - Fits a CP model to a tensor via optimization.
%   cp_wopt        - Fits a weighted CP model to a tensor via optimization.
X = cp_als(T, r);

%% PARAFAC2 DECOMPOSITION
r = 10;
[B,H,C,P,fit] = parafac2(A,r);

%% PARAFAC2 reconstruction
for i = 1:size(C,1)
  X(:,:,i) = B*diag(C(i,:))*(P{i}*H)';
end

%% ERROR
A_hat = double(X);
norm(tensor(A)-tensor(A_hat))

%% SHOW RESULTS
show_3dtensors(A,A_hat);
