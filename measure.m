clear all;

addpath CRC/

% -------------------------------------------------------------------------
% parameter setting
par.nClass        =   632;                 % the number of classes in the subset of AR database
par.nDim          =   5330;                 % the eigenfaces dimension
kappa             =   [0.001];             % l2 regularized parameter value

%--------------------------------------------------------------------------

%data loading (here we use the AR dataset as an example)
load('datasets/features.mat');
Tr_DAT   =   train_features';
trls     =   train_ids;
Tt_DAT   =   test_features';
ttls     =   test_ids;

tr_dat  =  Tr_DAT;
tt_dat  =  Tt_DAT;
% tr_dat  =  tr_dat./( repmat(sqrt(sum(tr_dat.*tr_dat)), [par.nDim,1]) );
% tt_dat  =  tt_dat./( repmat(sqrt(sum(tt_dat.*tt_dat)), [par.nDim,1]) );

% %--------------------------------------------------------------------------
% %eigenface extracting
% [disc_set,disc_value,Mean_Image]  =  Eigenface_f(Tr_DAT,par.nDim);
% tr_dat  =  disc_set'*Tr_DAT;
% tt_dat  =  disc_set'*Tt_DAT;
% tr_dat  =  tr_dat./( repmat(sqrt(sum(tr_dat.*tr_dat)), [par.nDim,1]) );
% tt_dat  =  tt_dat./( repmat(sqrt(sum(tt_dat.*tt_dat)), [par.nDim,1]) );

%-------------------------------------------------------------------------
%projection matrix computing
Proj_M = inv(tr_dat'*tr_dat+kappa*eye(size(tr_dat,2)))*tr_dat';


%-------------------------------------------------------------------------
%testing
ID = [];
for indTest = 1:size(tt_dat,2)
    [id]    = CRC_RLS(tr_dat,Proj_M,tt_dat(:,indTest),trls);
    ID      =   [ID id];
end
cornum      =   sum(ID==ttls);
Rec         =   [cornum/length(ttls)]; % recognition rate
fprintf(['recogniton rate is ' num2str(Rec) '\n']);