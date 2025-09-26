%% default for my project
% prj_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path (for mac)
prj_root_path = 'C:\Users\kaito\workspace\2025_EEG_Analysis\EEG_Analysis_using_fieldtrip'; %project path (for windows)
cd(prj_root_path);

prj_name = 'sample'; % adjust to project name

rawdata_path = fullfile(prj_root_path, 'rawdata', prj_name); % rawdata directory
result_path = fullfile(prj_root_path, 'results', prj_name); % result
addpath(fullfile(prj_root_path, 'code')); % code directory 

%% 1. read EEG data
hdrfile = fullfile(rawdata_path, 'sample.vhdr');
eegfile = fullfile(rawdata_path, 'sample.eeg');

cfg = [];
cfg.headerfile   = hdrfile;
EEG = ft_preprocessing(cfg); 

%% 2. read CSV file
seqfile = fullfile(rawdata_path, 'sequence_all.csv');
T = readtable(seqfile);
keys = T.Key; 

%% 3. filtering 
cfg = [];
cfg.bpfilter = 'yes';    
cfg.bpfreq = [1 30];  
cfg.bpfilttype  = 'firws'; 
EEG_bp = ft_preprocessing(cfg, EEG);

%% 4. segmenting 
cfgd = [];
cfgd.dataset = hdrfile;
cfgd.trialdef.eventtype  = 'Stimulus';
cfgd.trialdef.eventvalue = 's4';       
cfgd.trialdef.prestim    = 1.5;          
cfgd.trialdef.poststim   = 2.0;    
cfgd = ft_definetrial(cfgd);

cfg = [];
cfg.trl = cfgd.trl;
EEG_epoched = ft_redefinetrial(cfg, EEG_bp);

save(fullfile(rawdata_path, 'EEG.mat'), 'EEG_epoched', '-v7.3');

%% 5. labeling 
EEG_epoched.trialinfo = keys(:);
disp(EEG_epoched.trialinfo)

%% 6. divide
sel = EEG_epoched.trialinfo == "ff";
cfg = [];
cfg.trials = find(sel);
EEG_ff = ft_selectdata(cfg, EEG_epoched);

sel = EEG_epoched.trialinfo == "fc";
cfg = [];
cfg.trials = find(sel);
EEG_fc = ft_selectdata(cfg, EEG_epoched);

sel = EEG_epoched.trialinfo == "cf";
cfg = [];
cfg.trials = find(sel);
EEG_cf = ft_selectdata(cfg, EEG_epoched);

sel = EEG_epoched.trialinfo == "cc";
cfg = [];
cfg.trials = find(sel);
EEG_cc = ft_selectdata(cfg, EEG_epoched);

%% 7. save 
save(fullfile(rawdata_path, 'EEG_ff.mat'), 'EEG_ff', '-v7.3');
save(fullfile(rawdata_path, 'EEG_fc.mat'), 'EEG_fc', '-v7.3');
save(fullfile(rawdata_path, 'EEG_cf.mat'), 'EEG_cf', '-v7.3');
save(fullfile(rawdata_path, 'EEG_cc.mat'), 'EEG_cc', '-v7.3');