%% TENSOR t-SVD and inverse_t-svd
close all; clear all; clc;

%% LIBRARIES
addpath('libs/poblano_toolbox_1.1');
addpath('libs/tensor_toolbox_2.5');
addpath('libs/nway331');

%% LOAD DATASET
load('dataset/trafficdb/traffic_patches.mat');
A = double(imgdb{100});

%% Tensor t-SVD decomposition
[U,S,V] = tensor_t_svd(A);
% for k = 1:size(S,3)
%   Slr = zeros(size(S(:,:,k)));
%   for s = 1:48
%     Slr(s,s) = 1;
%   end
%   S(:,:,k) = S(:,:,k) .* Slr;
% end
[C] = tensor_product(U,S);
[A_hat] = tensor_product(C,tensor_transpose(V));

%% ERROR
norm(tensor(A)-tensor(A_hat))

%% SHOW RESULTS
show_3dtensors(A,A_hat);
