%% default for my project
prj_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path 
cd(prj_path);

raw_data_path  = fullfile(prj_path, 'rawdata'); % rawdata directory

addpath(fullfile(prj_path, 'code')); % code directory 

%% eeg and vhdr files 
datadir = fullfile(raw_data_path, 'sample_data');
hdrfile = fullfile(datadir, 's04.vhdr');
eegfile = fullfile(datadir, 's04.eeg');

%% read data
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