function [ Ycap ] = lraNTF( Y,opts )
%% Low-rank approximation based Non-Negative Tensor(CP) Factorization
%   Usage: Ycap=lraNCP(Y,opts);
%   Input: Y can be ktensor/ttensor/tensor/double
%  Output: Ycap is a nonnegative ktensor
%
%  Parameters:
%   opts.NumOfComp:  rank of Ycap
%   opts.lra_rank:   rank of low-rank approximation of Y
%   opts.CPalg:      a -mat file including the configuration of
%                           unconstrained CPD
%   opts.maxiter:    max. of global iterations    [default:50]
%   opts.maxiniter: max. of inner iterations. [default:20]
%   opts.nlssolver: [HALS|APG|MU] the algorithm used for solving NLS
%                      sub-problem
%   opts.initmode:  [cp|random]
%   opts.tol:        stop threshold. [default:1e-6]
%   opts.sparsity  an N-by-1 vector in [0,1) to specify the sparsity of
%                   results (l1-norm based sparsity).
%
%
%
% Cite this work currently:
%  Guoxu Zhou; Cichocki, A.; Shengli Xie; , "Fast Nonnegative Matrix/Tensor Factorization Based on Low-Rank Approximation,"
%  IEEE Transactions on Signal Processing, vol.60, no.6, pp.2928-2940, June 2012
%  doi: 10.1109/TSP.2012.2190410
%  URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6166354&isnumber=6198804
%
% By Guoxu Zhou
% E-Mail: zhouguoxu@gmail.com
% Last updated: 2013-09-09

