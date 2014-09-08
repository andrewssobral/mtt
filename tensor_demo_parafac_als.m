%% TENSOR PARAFAC (ALS solver)
close all; clear all; clc;

%% LIBRARIES
addpath('libs/poblano_toolbox_1.1');
addpath('libs/tensor_toolbox_2.5');
addpath('libs/nway331');

%% LOAD DATASET
load('dataset/trafficdb/traffic_patches.mat');
A = double(imgdb{100});
T = tensor(A);

%% CP DECOMPOSITION
n = size(A);
r = 10;

% Find the closest length - r ktensor ...
%   cp_als         - Compute a CP decomposition of any type of tensor.
%   cp_apr         - Compute nonnegative CP with alternating Poisson regression.
%   cp_nmu         - Compute nonnegative CP with multiplicative updates.
%   cp_opt         - Fits a CP model to a tensor via optimization.
%   cp_wopt        - Fits a weighted CP model to a tensor via optimization.
X = cp_als(T, r);

%% ERROR
A_hat = double(X);
norm(tensor(A)-tensor(A_hat))

%% SHOW RESULTS
show_3dtensors(A,A_hat);
