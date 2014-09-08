%%
%
function [LT] = lraNTFbgmodel(T,lraNTF_opts)
  %% 4D TENSOR DEMO
  % inputPath = 'dataset/demo.avi';
  % [video nFrame vidWidth vidHeight] = load_input(inputPath);
  % T = im2double(video); size(T)
  
  %% 3D TENSOR DEMO
  % load('C:/ABSLibrary/dataset/trafficdb/trafficdb/traffic_patches.mat');
  % V = imgdb{100};
  % V = im2double(V);
  %T = tensor(V); size(T)

  %% Factorize subtensors with PARAFAC/CP algorithm with R = 1
  sT = size(T);
  blksize = 8;
  tdim = numel(size(T));

  if(tdim == 4) 
    d = zeros(sT(4),prod(sT(1:2))/blksize^2);
    Tlen = size(T,4);
  end
  if(tdim == 3) 
    d = zeros(sT(3),prod(sT(1:2))/blksize^2); 
    Tlen = size(T,3);
  end

  kblk = 0;
  xy = zeros(1,2);
  %tic;
  displog('Factorizing subtensors with Parafac/CP algorithm');
  for xu = 1:8:sT(1)-7
    for yu = 1:8:sT(2)-7
      kblk = kblk+1;

      if(tdim == 4) 
        Tblk = T(xu:xu+blksize-1, yu:yu+blksize-1,:,:);
        % show_4dvideo(Tblk);
        Yblk = permute(tensor(Tblk),[4 1 2 3]);
      end
      
      if(tdim == 3)
        Tblk = T(xu:xu+blksize-1, yu:yu+blksize-1,:);
        Yblk = permute(tensor(Tblk),[3 1 2]);
        % show_3dvideo(Tblk);
      end
      
      % lraNTF_opts = struct('NumOfComp',1,'CPalg','CP_HALS_opts.mat',...
      %  'lra_rank',2,'maxiter',500,'nlssolver','hals','initmode','cp','lra',true);
      [Ycap] = lraNTF(Yblk,lraNTF_opts);
      d(:,kblk) = double(Ycap.U{1});
      xy(kblk,:) = [xu yu];

      %[X_als,Uinit,out] = cp_als(Yblk,1);
      % X_als2 = double(permute(tensor(X_als),[2 3 4 1])); size(X_als2)
      % show_4dvideo(X_als2);
    end
  end
  %toc

  %% Find stationary blocks and build background model
  %tic;
  displog('Finding stationary blocks and build background model');
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
  %toc
  displog('Finished');
  %%
  LT = repmat(Imbgr,[1 1 Tlen]);
end
