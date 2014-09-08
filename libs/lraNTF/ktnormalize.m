function [ Y ] = ktnormalize( Y,nrm,nnproj )
if nargin==1
    nrm=[];nnproj=[];
elseif nargin==2
    nnproj=[];
end
if isempty(nrm)
    nrm=2;
end
if isempty(nnproj)
    nnproj=true;
end

if strcmpi(class(Y),'ktensor')
    I=size(Y);
    N=numel(I);
    J=length(Y.lambda);
    switch nrm
        case 0
            for n=1:N
                ts=0:I(n):(J-1)*I(n);
                [temp idx]=max(abs(Y.U{n}));
                d=Y.U{n}(idx+ts);
                d=sign(d).*max(abs(d),eps);
                Y.U{n}=bsxfun(@rdivide,Y.U{n},d);
                Y.lambda=Y.lambda.*d';
            end
        case 1
            for n=1:N
                d=max(sum(abs(Y.U{n})),eps);
                Y.U{n}=bsxfun(@rdivide,Y.U{n},d);
                Y.lambda=Y.lambda.*d';
            end                
        case 2
            for n=1:N
                d=max(sum(Y.U{n}.^2),eps);
                Y.U{n}=bsxfun(@rdivide,Y.U{n},d);
                Y.lambda=Y.lambda.*d';
            end
        otherwise
            disp('Unsupported norm.');
    end
    
    [temp idx]=sort(abs(Y.lambda),'descend');
    Y.lambda=Y.lambda(idx);
    for n=1:N
        Y.U{n}=Y.U{n}(:,idx);
    end
    
    %% nonnegative projection
    if nnproj        
        ts=0:I(n):(J-1)*I(n);
        [temp idx]=max(abs(Y.U{n}));
        d=sign(Y.U{n}(idx+ts));
        Y.U{n}=bsxfun(@rdivide,Y.U{n},d);
        Y.lambda=Y.lambda.*d';
    end
end

end

