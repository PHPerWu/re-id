
function d = return_distance(x,y,dist)

%     if nargin==3
%         [a,b]=size(x);
%         covar = eye(a,a);
%     end

    %I assume that x and y are column vectors
    if strcmp(dist,'euc')==1
        d = norm(x-y);
    elseif strcmp(dist,'ctb')==1
        d = sum(abs(x-y));
    elseif strcmp(dist,'cos')==1
        norm_x = norm(x);
        norm_y = norm(y);
        d = - (x'*y)/(norm_x*norm_y);
    elseif strcmp(dist,'chisq')==1
        d = slmetric_pw(x,y,'chisq');
    elseif strcmp(dist,'intersect')==1
        d = slmetric_pw(x,y,'intersect');
    else
        disp('The specified distance is not supported!')
        return;
    end
end