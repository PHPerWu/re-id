

function [ver_rate, miss_rate, rates_and_threshs] = produce_ROC(true_scores, false_scores, resolu)

%% Init 
ver_rate = [];
miss_rate = [];
rates_and_threshs = [];

%% Check inputs
%check number of inputs
if nargin <2
    disp('Wrong number of input parameters! The function requires at least two input arguments.')
    return;
elseif nargin >3
    disp('Wrong number of input parameters! The function takes no more than three input arguments.')
    return;
elseif nargin==2
    resolu = 2500;
end

%check for values
    if isnumeric(resolu)~=1
        disp('The resolution parameter needs to be a numeric value!')
        return;
    end
    
    if resolu<500
        disp('Resultion for ROC is rather small. Incerasing to 500!')
        resolu = 500;
    end
    
    if isvector(true_scores)~=1
        disp('The "true scores" parameter needs to be a numeric vector!')
        return;
    end
    
    if isvector(false_scores)~=1
        disp('The "false scores" parameter needs to be a numeric vector!')
        return;
    end
    
    if isnumeric(true_scores)~=1
        disp('The "true scores" parameter needs to be a numeric vector!')
        return;
    end
    
    if isnumeric(false_scores)~=1
        disp('The "false scores" parameter needs to be a numeric vector!')
        return;
    end

%% Init operations
cli_scor = numel(true_scores);
imp_scor = numel(false_scores);

dmax = true_scores;
dmin = false_scores;


%% Compute ROC curve data

%get maximum and minimum value
dminx = min(true_scores);
dmaxx = max(false_scores);

%computing FRE curve
delta = (dmaxx-dminx)/resolu;
counter=1;
fre = zeros(1,resolu);
for trash=dminx:delta:dmaxx
    num_ok = sum(dmax<trash);
    fre(1,counter) = 1-(num_ok/cli_scor);
    counter = counter+1;
end

%copmuting FAE curve
counter=1;
fae = zeros(1,resolu);
for trash=dminx:delta:dmaxx
    num_ok = sum(dmin<trash);
    fae(1,counter) = (num_ok/imp_scor);
    counter = counter+1;
end

%% Computing characteristic error rates and corresponding thresholds

%Minimal HTER
C=fae+fre;
[dummy,index] = min(C);
rates_and_threshs.minHTER_er  = C(index)/2;
rates_and_threshs.minHTER_tr  = dminx+(index-1)*delta;
rates_and_threshs.minHTER_frr = sum(dmax>(dminx+(index-1)*delta))/cli_scor;
rates_and_threshs.minHTER_ver = 1-rates_and_threshs.minHTER_frr;
rates_and_threshs.minHTER_far = sum(dmin<(dminx+(index-1)*delta))/imp_scor;


%EER, FRR = 0.1FAR, FRR = 10FAR, @0.01%FAR, @0.1%FAR, @1%FAR
maxi1=Inf;
maxi2=Inf;
maxi3=Inf;
maxi4=Inf;
maxi5=Inf;
maxi6=Inf;
for i=1:resolu+1
    %EER
    if abs(fae(i)-fre(i))<maxi1
       index1 = i;
       maxi1=abs(fae(i)-fre(i));
    end
    
    %FRR = 0.1FAR
    if abs(0.1*fae(i)-fre(i))<maxi2
       index2 = i;
       maxi2=abs(0.1*fae(i)-fre(i));
    end
    
    %FRR = 10FAR
    if abs(10*fae(i)-fre(i))<maxi3
       index3 = i;
       maxi3=abs(10*fae(i)-fre(i));
    end
    
    %@0.01%FAR
    if abs(fae(i)-0.01/100)<maxi4
       index4 = i;
       maxi4=abs(fae(i)-0.01/100);
    end
    
    %@0.1%FAR
    if abs(fae(i)-0.1/100)<maxi5
       index5 = i;
       maxi5=abs(fae(i)-0.1/100);
    end
    
    %@1%FAR
    if abs(fae(i)-1/100)<maxi6
       index6 = i;
       maxi6=abs(fae(i)-1/100);
    end
    
end

%EER
rates_and_threshs.EER_er  = C(index1)/2;
rates_and_threshs.EER_tr  = dminx+(index1-1)*delta;
rates_and_threshs.EER_frr = sum(dmax>(dminx+(index1-1)*delta))/cli_scor;
rates_and_threshs.EER_ver = 1-rates_and_threshs.EER_frr;
rates_and_threshs.EER_far = sum(dmin<(dminx+(index1-1)*delta))/imp_scor;

%FRR = 0.1FAR
rates_and_threshs.FRR_01FAR_er  = C(index2)/2;
rates_and_threshs.FRR_01FAR_tr  = dminx+(index2-1)*delta;
rates_and_threshs.FRR_01FAR_frr = sum(dmax>(dminx+(index2-1)*delta))/cli_scor;
rates_and_threshs.FRR_01FAR_ver = 1-rates_and_threshs.FRR_01FAR_frr;
rates_and_threshs.FRR_01FAR_far = sum(dmin<(dminx+(index2-1)*delta))/imp_scor;

%FRR = 10FAR
rates_and_threshs.FRR_10FAR_er  = C(index3)/2;
rates_and_threshs.FRR_10FAR_tr  = dminx+(index3-1)*delta;
rates_and_threshs.FRR_10FAR_frr = sum(dmax>(dminx+(index3-1)*delta))/cli_scor;
rates_and_threshs.FRR_10FAR_ver = 1-rates_and_threshs.FRR_10FAR_frr;
rates_and_threshs.FRR_10FAR_far = sum(dmin<(dminx+(index3-1)*delta))/imp_scor;

%001FAR
rates_and_threshs.VER_001FAR_er  = C(index4)/2;
rates_and_threshs.VER_001FAR_tr  = dminx+(index4-1)*delta;
rates_and_threshs.VER_001FAR_frr = sum(dmax>(dminx+(index4-1)*delta))/cli_scor;
rates_and_threshs.VER_001FAR_ver = 1-rates_and_threshs.VER_001FAR_frr;
rates_and_threshs.VER_001FAR_far = sum(dmin<(dminx+(index4-1)*delta))/imp_scor;

%01FAR
rates_and_threshs.VER_01FAR_er  = C(index5)/2;
rates_and_threshs.VER_01FAR_tr  = dminx+(index5-1)*delta;
rates_and_threshs.VER_01FAR_frr = sum(dmax>(dminx+(index5-1)*delta))/cli_scor;
rates_and_threshs.VER_01FAR_ver = 1-rates_and_threshs.VER_01FAR_frr;
rates_and_threshs.VER_01FAR_far = sum(dmin<(dminx+(index5-1)*delta))/imp_scor;

%1FAR
rates_and_threshs.VER_1FAR_er  = C(index6)/2;
rates_and_threshs.VER_1FAR_tr  = dminx+(index6-1)*delta;
rates_and_threshs.VER_1FAR_frr = sum(dmax>(dminx+(index6-1)*delta))/cli_scor;
rates_and_threshs.VER_1FAR_ver = 1-rates_and_threshs.VER_1FAR_frr;
rates_and_threshs.VER_1FAR_far = sum(dmin<(dminx+(index6-1)*delta))/imp_scor;


%set outputs
ver_rate = 1- fre;
miss_rate = fae;





























