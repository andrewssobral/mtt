%% TENSOR OPERATIONS
close all; clear all; clc;

%% LIBRARIES
addpath('libs/poblano_toolbox_1.1');
addpath('libs/tensor_toolbox_2.5');
addpath('libs/nway331');

%% TENSORS
%A = reshape(1:24,[2,3,4]);
%B = reshape(1:24,[2,3,4]);
A = reshape(1:12,[2,2,3]);
B = reshape(1:12,[2,2,3]);

%% TENSOR OPERATIONS
A1 = tensor_unfolding(A,1);
A2 = tensor_unfolding(A,2);
A3 = tensor_unfolding(A,3);
[A1,A2,A3] = tensor_matricization(A);

M22 = reshape(1:4,[2,2]);
M33 = reshape(1:9,[3,3]);
B1 = tensor_nmodeproduct(A,M22,1);
B2 = tensor_nmodeproduct(A,M22,2);
B3 = tensor_nmodeproduct(A,M33,3);

Au = tensor_unfold(A);
A_hat = tensor_fold(Au,size(A));

[A1_] = tensor_slices_frontal(A);
[A2_] = tensor_slices_lateral(A);
[A3_] = tensor_slices_horizontal(A);

[At1_] = tensor_fibers_column(A);
[At2_] = tensor_fibers_row(A);
[At3_] = tensor_fibers_tube(A);

Bt = tensor_transpose(B);
[C] = tensor_product(A,B);
