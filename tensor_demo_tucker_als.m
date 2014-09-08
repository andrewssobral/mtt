%% TENSOR Tucker (ALS solver)
%%% Tucker Alternating Least-Squares
close all; clear all; clc;

%% LIBRARIES
addpath('libs/poblano_toolbox_1.1');
addpath('libs/tensor_toolbox_2.5');
addpath('libs/nway331');

%% LOAD DATASET
load('dataset/trafficdb/traffic_patches.mat');
A = double(imgdb{100});
T = tensor(A);

%% Tucker DECOMPOSITION
n = size(A);
%r = min(n)-1;
r = 10;
%for r = 1:min(n)
% Find the closest length -[ r r r ] ttensor ...
X = tucker_als(tensor(A),[r r r]);
%end

%% ERROR
A_hat = double(X);
norm(tensor(A)-tensor(A_hat))

%% SHOW RESULTS
show_3dtensors(A,A_hat);
