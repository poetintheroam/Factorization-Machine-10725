 function grad_g_Z=grad_g(Z,w,y,X)
 	[n,p]=size(X);
    grad_g_Z=-X'*diag(y-X*w-diag(X*Z*X'))*X; %%% not sure which one is right or both wrong...
    % grad_g_Z=-X'*ones(n,1)*(y-X*w-diag(X*Z*X'))'*X; %%% but from f_value they are the same...
 	%
 end