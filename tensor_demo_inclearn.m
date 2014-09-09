%% INCREMENTAL TENSOR LEARNING
%%% Incremental tensor analysis: Theory and applications (2008)
%%% http://dl.acm.org/citation.cfm?id=1409621
close all; clear all; clc;

%% LIBRARIES
addpath('libs/poblano_toolbox_1.1');
addpath('libs/tensor_toolbox_2.5');
addpath('libs/nway331');
addpath('libs/itl');

%% TENSORS
A = full(ttensor(tenrand([2,3,4]),{rand(10,2),rand(30,3), rand(40,4)}));
B = full(ttensor(tenrand([2,3,4]),{rand(10,2),rand(30,3), rand(40,4)}));
D = {A,A,A,A,A,B,B,B,B,B};

%% Dynamic Tensor Decomposition (DTA) 
%%% Compute DTA with no forgetting factor
[T,C] = DTA(D{1},[2,3,4]);
for i = 2:10
  [T,C] = DTA(D{i},[2,3,4],C);
  err = norm(full(T)-D{i})/norm(D{i});
  fprintf('tensor #%d has error %f\n',i,err);
end
%%% Compute DTA with forgetting factor alpha = 0.1
[T,C] = DTA(D{1},[2,3,4]);
alpha = 0.1;
for i = 2:10
  [T,C] = DTA(D{i},[2,3,4],C, alpha);
  err = norm(full(T)-D{i})/norm(D{i});
  fprintf('tensor #%d has error %f\n',i,err);
end

%% Streaming Tensor Decomposition (STA)
%%% Compute STA with no forgetting factor
[T,S] = STA(D{1},[2,3,4]);
for i = 2:10
  [T,S] = STA(D{i},[2,3,4],T,S);
  err = norm(full(T)-D{i})/norm(D{i});
  fprintf('tensor #%d has error %f\n',i,err);
end
%%% Compute STA with forgetting factor alpha = 0.9
[T,S] = STA(D{1},[2,3,4]);
alpha = 0.9;
for i = 2:10
  [T,S] = STA(D{i},[2,3,4],T,S, alpha);
  err = norm(full(T)-D{i})/norm(D{i});
  fprintf('tensor #%d has error %f\n',i,err);
end

%% Window-based Tensor Decomposition (WTA)
[T,C] = WTA(D{1},[2,3,4]);
for i = 2:10
  [T,C] = WTA(D{i},[2,3,4],tensor(T));
  err = norm(full(T)-D{i})/norm(D{i});
  fprintf('tensor #%d has error %e\n',i,err);
end
