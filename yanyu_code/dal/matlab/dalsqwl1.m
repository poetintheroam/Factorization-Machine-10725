% dalsqwl1 - DAL with the weighted squared loss and the L1 regularization
%
% Overview:
%  Solves the optimization problem:
%   xx = argmin 0.5*sum(weight.*(A*x-bb).^2) + lambda*||x||_1
%
% Syntax:
%  [xx,status]=dalsqwl1(xx, A, bb, lambda, weight, <opt>)
%
% Inputs:
%  xx     : initial solution ([nn,1])
%  A      : the design matrix A ([mm,nn]) or a cell array {fA, fAT, mm, nn}
%           where fA and fAT are function handles to the functions that
%           return A*x and A'*x, respectively, and mm and nn are the
%           numbers of rows and columns of A.
%  bb     : the target vector ([mm,1])
%  lambda : the regularization constant
%  weight : positive weight vector ([mm,1])
%  <opt>  : list of 'fieldname1', value1, 'filedname2', value2, ...
%   stopcond : stopping condition, which can be
%              'pdg'  : Use relative primal dual gap (default)
%              'fval' : Use the objective function value
%           (see dal.m for other options)
% Outputs:
%  xx     : the final solution ([nn,1])
%  status : various status values
%
% Example:
% m = 1024; n = 4096; k = round(0.04*n); A=randn(m,n);
% w0=randsparse(n,k); bb=A*w0+0.01*randn(m,1);
% lambda=0.1*max(abs(A'*bb));
% weight=(1:m)';
% [ww,stat]=dalsqwl1(zeros(n,1), A, bb, lambda, weight);
% figure, plot(bb-A*ww);
%
% Copyright(c) 2009 Ryota Tomioka
% This software is distributed under the MIT license. See license.txt

function [ww,status]=dalsqwl1(ww,A,bb, lambda, weight, varargin)

opt=propertylist2struct(varargin{:});
opt=set_defaults(opt,'solver','cg',...
                     'stopcond','pdg');



prob.floss    = struct('p',@loss_sqpw,'d',@loss_sqdw,'args',{{bb,weight}});
prob.fspec    = @(xx)abs(xx);
prob.dnorm    = @(vv)max(abs(vv));
prob.obj      = @objdall1;
prob.softth   = @l1_softth;
prob.stopcond = opt.stopcond;
prob.ll       = -inf*ones(size(bb));
prob.uu       = inf*ones(size(bb));
prob.Ac       =[];
prob.bc       =[];
prob.info     =[];

if isequal(opt.solver,'cg')
  prob.hessMult = @hessMultdall1;
end

if isequal(opt.stopcond,'fval')
  opt.feval = 1;
end

if isnumeric(A)
  A = A(:,:);
  [mm,nn]=size(A);
  At=A';
  fA = struct('times',@(x)A*x,...
              'Ttimes',@(x)At*x,...
              'slice', @(I)A(:,I));
  clear At;
elseif iscell(A)
  mm = A{3};
  nn = A{4};
  fAslice = @(I)A{1}(sparse(I,1:length(I),ones(length(I),1), nn, length(I)));
  fA = struct('times',A{1},...
              'Ttimes',A{2},...
              'slice',fAslice);
else
  error('A must be either numeric or cell {@(x)A*x, @(y)(A''*y), mm, nn}');
end

prob.mm       = mm;
prob.nn       = nn;

[ww,uu,status]=dal(prob,ww,[],fA,[],lambda,opt);

