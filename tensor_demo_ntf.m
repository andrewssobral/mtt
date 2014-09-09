%% TENSOR HOSVD and iHOSVD
close all; clear all; clc;

%% LIBRARIES
addpath('libs/poblano_toolbox_1.1');
addpath('libs/tensor_toolbox_2.5');
addpath('libs/nway331');
addpath('libs/betaNTF');
% addpath('libs/tensorlab'); % for slice3(...)

%% LOAD DATASET
load('dataset/trafficdb/traffic_patches.mat');
A = double(imgdb{100});
% slice3(A), colormap('gray');

%% beta-NTF
% Compute a simple NTF model of 10 components
r = 10;
[W,H,Q,A_hat] = betaNTF(A,r); 

%% For reconstruction
for i = 1:r, B_hat(:,:,i) = W * diag(Q(i,:)) * H'; end 
imshow(B_hat(:,:,1),[0 255]);

%% ERROR
A_err = norm(tensor(A)-tensor(A_hat))

%% SHOW TENSORS
show_3dtensors(A,A_hat);

%% CONVERT TO AVI
convert_video3d_to_avi(A_hat,'output.avi');
