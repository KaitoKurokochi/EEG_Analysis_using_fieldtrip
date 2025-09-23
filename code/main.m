%% default for my project
% prj_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path (for mac)
prj_root_path = 'C:\Users\kaito\workspace\2025_EEG_Analysis\EEG_Analysis_using_fieldtrip'; %project path (for windows)
cd(prj_root_path);

prj_name = 'sample'; % adjust to project name

rawdata_path = fullfile(prj_root_path, 'rawdata', prj_name); % rawdata directory
result_path = fullfile(prj_root_path, 'results', prj_name); % result
addpath(fullfile(prj_root_path, 'code')); % code directory 

%% read data
hdrfile = fullfile(rawdata_path, 'sample.vhdr');
eegfile = fullfile(rawdata_path, 'sample.eeg');

cfg = [];
cfg.dataset = hdrfile;
EEG = ft_preprocessing(cfg);

%% filtering
cfg = [];
cfg.bpfilter = 'yes';    
cfg.bpfreq = [1 30];  
cfg.bpfilttype  = 'firws';
EEG_bp = ft_preprocessing(cfg, EEG);

%% cmp
% 生データ
cfg = [];
cfg.viewmode  = 'vertical';    % 電極ごとに縦に並べる
cfg.blocksize = 10;            % 10秒単位でスクロール
ft_databrowser(cfg, EEG);

% 1–30 Hz 後
cfg = [];
cfg.viewmode  = 'vertical';
cfg.blocksize = 10;
ft_databrowser(cfg, EEG_bp);

%% ICA 
cfg = []; 
cfg.method = 'runica';
EEG_ICA = ft_componentanalysis(cfg, EEG_bp);

