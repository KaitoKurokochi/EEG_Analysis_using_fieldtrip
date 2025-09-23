%% default for my project
% prj_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path (for mac)
prj_root_path = 'C:\Users\kaito\workspace\2025_EEG_Analysis\EEG_Analysis_using_fieldtrip'; %project path (for windows)
cd(prj_root_path);

prj_name = 'sample'; % adjust to project name

rawdata_path = fullfile(prj_root_path, 'rawdata', prj_name); % rawdata directory
result_path = fullfile(prj_root_path, 'results', prj_name); % result
addpath(fullfile(prj_root_path, 'code')); % code directory 

%% read data
hdrfile = fullfile(rawdata_path, 's04.vhdr');
eegfile = fullfile(rawdata_path, 's04.eeg');

cfg = [];
cfg.trialfun     = 'trialfun_affcog';
cfg.headerfile   = hdrfile;
cfg.datafile     = eegfile;
cfg = ft_definetrial(cfg);

%% preprocessing and referencing 
% Baseline-correction options
cfg.demean          = 'yes';
cfg.baselinewindow  = [-0.2 0];

% Fitering options
cfg.lpfilter        = 'yes';
cfg.lpfreq          = 100;

% Re-referencing options - see explanation above
cfg.implicitref   = 'LM';
cfg.reref         = 'yes';
cfg.refchannel    = {'LM' 'RM'};

data = ft_preprocessing(cfg);

%% ERP graph -> 各電極の電位の時系列データをグラフで
cfg = [];
cfg.viewmode = 'vertical';   
cfg.channel  = 'all';
cfg.blocksize = 5;          
ft_databrowser(cfg, data);