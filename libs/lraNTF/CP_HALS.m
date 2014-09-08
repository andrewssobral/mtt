function [ Ycap ] = CP_HALS( Y, opts )
%% CP_HALS:  canonical polyadic decomposition (CPD) of tensor Y.
%  Usage: Ycap=CP_HALS(Y,opts);
%      Output: Ycap is a ktensor
%  Parameters:
%        opts.NumOfComp: rank of Ycap (number of columns of Ycap.U{n};
%            .maxiter: [200] maximum number of main iterations
%            .maxiniter: [20] maximum number of internal iterations
%            .tol: [1e-6]
%            .nonnegativity: an N-by-1 vector of {0,1}. If nonnegativity(n)=1 then Ycap.U{n}
%                   will be nonnegative.
%            .sparity: an N-by-1 vector in [0,1). If sparsity(n)=s, then
%               Ycap.U{n} will be sparse.
%            .trackit: check the results.
%
% You may cite these papers:
%  [1] Guoxu Zhou; Cichocki, A.; Shengli Xie; , "Fast Nonnegative Matrix/Tensor Factorization Based on Low-Rank Approximation," 
%       Signal Processing, IEEE Transactions on , vol.60, no.6, pp.2928-2940, June 2012
%       URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6166354&isnumber=6198804
%  [2] TDALAB: A Matlab Toolbox for Tensor Decompsition and Analysis,
%        Available at: http://bsp.brain.riken.jp/TDALAB
%  [3] A. Cichocki and Phan A-H. Fast local algorithms for large scale Nonnegative Matrix and Tensor Factorizations .
%      IEICE Transaction on Fundamentals, (2009)
%
%  This function depends on the TensorToolbox available at: 
%               http://www.sandia.gov/~tgkolda/TensorToolbox/index-2.5.html
%
% by Guoxu Zhou
% E-Mail: zhouguoxu@gmail.com
% Last updated: 2013-09-09
