%% TENSOR - SUBTENSOR - NTF-hals 
close all; clear all; clc;

%% LIBRARIES
addpath('libs/poblano_toolbox_1.1');
addpath('libs/tensor_toolbox_2.5');
addpath('libs/nway331');
addpath('libs/lraNTF');

%% 4D TENSOR
inputPath = 'dataset/trafficdb/videos/100.avi';
[video nFrame vidWidth vidHeight] = load_input(inputPath);
% show_4dvideo(video);
T = im2double(video); size(T)

%% 3D TENSOR
load('dataset/trafficdb/traffic_patches.mat');
V = imgdb{100};
V = im2double(V);
T = tensor(V); size(T)

%% Factorize subtensors with PARAFAC/CP algorithm with R = 1
sT = size(T);
blksize = 8;
tdim = numel(size(T));

if(tdim == 4) d = zeros(sT(4),prod(sT(1:2))/blksize^2); end
if(tdim == 3) d = zeros(sT(3),prod(sT(1:2))/blksize^2); end

kblk = 0;
xy = zeros(1,2);
tic;
disp('Factorizing subtensors with Parafac algorithm');
for xu = 1:8:sT(1)-7
  for yu = 1:8:sT(2)-7
    kblk = kblk+1;
    
    if(tdim == 4) Tblk = T(xu:xu+blksize-1, yu:yu+blksize-1,:,:); end
    if(tdim == 3) Tblk = T(xu:xu+blksize-1, yu:yu+blksize-1,:); end
    
    % show_4dvideo(Tblk); show_3dvideo(Tblk);
    
    if(tdim == 4) Yblk = permute(tensor(Tblk),[4 1 2 3]); end
    if(tdim == 3) Yblk = permute(tensor(Tblk),[3 1 2]); end
    
    lraNTF_opts = struct('NumOfComp',1,'CPalg','CP_HALS_opts.mat',...
      'lra_rank',2,'maxiter',500,'nlssolver','hals','initmode','cp','lra',true);
    [Ycap] = lraNTF(Yblk,lraNTF_opts);
    d(:,kblk) = double(Ycap.U{1});
    xy(kblk,:) = [xu yu];
    
    %[X_als,Uinit,out] = cp_als(Yblk,1);
    % X_als2 = double(permute(tensor(X_als),[2 3 4 1])); size(X_als2)
    % show_4dvideo(X_als2);
  end
end
toc

%% Find stationary blocks and build background model
tic;
disp('Finding stationary blocks and build background model');
maxd = max(d); mind = min(d);
thresh = 0.005;

if(tdim == 4) Imbgr = zeros(sT(1:3)); end
if(tdim == 3) Imbgr = zeros(sT(1:2)); end

for k = 1:size(d,2)
  edges = [mind(k):thresh:maxd(k) maxd(k)+eps];
  [n,bin] = histc(d(:,k),edges);
  m = mode(bin);
  indbgr = find((d(:,k) >= edges(m)) & (d(:,k) <= edges(m+1)));
  
  if(tdim == 4) 
    bgrblk = median(T(xy(k,1):xy(k,1)+blksize-1, xy(k,2):xy(k,2)+blksize-1,:,indbgr),4); 
    Imbgr(xy(k,1):xy(k,1)+blksize-1, xy(k,2):xy(k,2)+blksize-1,:) = bgrblk;
  end
  
  if(tdim == 3) 
    bgrblk = median(double(T(xy(k,1):xy(k,1)+blksize-1, xy(k,2):xy(k,2)+blksize-1,indbgr)),3); 
    Imbgr(xy(k,1):xy(k,1)+blksize-1, xy(k,2):xy(k,2)+blksize-1) = bgrblk;
  end
end
toc
imshow(Imbgr);