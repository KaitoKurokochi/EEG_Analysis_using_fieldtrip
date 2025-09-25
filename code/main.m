%% default for my project
prj_root_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path (for mac)
% prj_root_path = 'C:\Users\kaito\workspace\2025_EEG_Analysis\EEG_Analysis_using_fieldtrip'; %project path (for windows)
cd(prj_root_path);

prj_name = 'sample'; % adjust to project name
rawdata_path = fullfile(prj_root_path, 'rawdata', prj_name); % rawdata directory
result_path = fullfile(prj_root_path, 'results', prj_name); % result
addpath(fullfile(prj_root_path, 'code')); % code directory 

%% read data
hdrfile = fullfile(rawdata_path, 's04.vhdr');
eegfile = fullfile(rawdata_path, 's04.eeg');

cfg = [];
cfg.dataset = hdrfile;
EEG = ft_preprocessing(cfg);

%% filtering
cfg = [];
cfg.bpfilter = 'yes';    
cfg.bpfreq = [1 5];  
cfg.bpfilttype  = 'firws'; 
EEG_bp = ft_preprocessing(cfg, EEG);

%% cmp
% amp
cfg = [];
cfg.viewmode  = 'vertical'; 
cfg.blocksize = 10;            
ft_databrowser(cfg, EEG);

cfg = [];
cfg.viewmode  = 'vertical';
cfg.blocksize = 10;
ft_databrowser(cfg, EEG_bp);

% time-frequency power
% -> https://www.fieldtriptoolbox.org/workshop/madrid2019/tutorial_freq/
cfgp = [];
cfgp.output = 'pow'; % power spectrum density 
cfgp.channel = 'all';
cfgp.method    = 'mtmfft'; % multi-taper method FFT
cfgp.taper     = 'boxcar'; % taper 
cfgp.foi = 0.5:0.25:45; % frequencies of interest 

fr_before = ft_freqanalysis(cfgp, EEG);
fr_after = ft_freqanalysis(cfgp, EEG_bp);

figure; hold on;
plot(fr_before.freq, fr_before.powspctrm(61,:))
plot(fr_after.freq, fr_after.powspctrm(61,:))
legend('before BP', 'after BP');
xlabel('Frequency (Hz)');
ylabel('absolute power (uV^2)');
grid on;


%% ICA 
cfg = []; 
cfg.method = 'runica';
EEG_ICA = ft_componentanalysis(cfg, EEG_bp);

