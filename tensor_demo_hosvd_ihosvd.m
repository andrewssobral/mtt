%% TENSOR HOSVD and iHOSVD
close all; clear all; clc;

%% LIBRARIES
addpath('libs/poblano_toolbox_1.1');
addpath('libs/tensor_toolbox_2.5');
addpath('libs/nway331');

%% LOAD DATASET
load('dataset/trafficdb/traffic_patches.mat');
A = double(imgdb{100});
T = tensor(A);

%% TENSOR HOSVD
[core,U] = tensor_hosvd(T);

%%% Truncate mode-3 basis matrice (keep the first eigenvalue)
%%% tensor_hosvd(tensor,[mode-1 mode-2 mode-3])
[core,U] = tensor_hosvd(T,[0 0 1]);

%%% Perform mode-3 rank-2 partial svd
%%% tensor_hosvd(tensor,[truncate mode-n],[partial svd in mode-n])
[core,U] = tensor_hosvd(T,0,[0 0 2]);

%% TENSOR iHOSVD
[T_hat] = tensor_ihosvd(core,U);
A_hat = double(T_hat);

%% ERROR
A_err = norm(tensor(A)-tensor(A_hat))

%% SHOW TENSORS
show_3dtensors(A,A_hat);

%% CONVERT TO AVI
convert_video3d_to_avi(A_hat,'output.avi');
