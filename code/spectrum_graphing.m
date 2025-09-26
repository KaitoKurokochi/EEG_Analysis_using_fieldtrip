%% default for my project
% prj_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path (for mac)
prj_root_path = 'C:\Users\kaito\workspace\2025_EEG_Analysis\EEG_Analysis_using_fieldtrip'; %project path (for windows)
cd(prj_root_path);

prj_name = 'sample'; % adjust to project name

rawdata_path = fullfile(prj_root_path, 'rawdata', prj_name); % rawdata directory
result_path = fullfile(prj_root_path, 'results', prj_name); % result
addpath(fullfile(prj_root_path, 'code')); % code directory 

%% 1. read EEG data
S = load(fullfile(rawdata_path, 'EEG.mat'));
EEG = S.EEG_epoched;

%% 2. frequecy analysis
cfg = [];
cfg.output      = 'pow'; % power 
cfg.channel     = 'Cz';             
cfg.method      = 'mtmconvol'; 
cfg.taper       = 'hanning';
cfg.foi         = 2:1:40;           
cfg.t_ftimwin   = 5 ./ cfg.foi;     
cfg.toi         = -1.5:0.02:2.0;    
cfg.pad         = 'nextpow2';
cfg.keeptrials  = 'no';             

TFR = ft_freqanalysis(cfg, EEG);

%% 3. creating a graph for Cz channel
cfgp = [];
cfgp.channel = 'Cz';
cfgp.zlim    = 'maxabs';   
cfgp.xlim    = [-1.5 2.0]; 
cfgp.ylim    = [4 40];     
ft_singleplotTFR(cfgp, TFR);  
title('ff / Cz - TFR (Hanning)');