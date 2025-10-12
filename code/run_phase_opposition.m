%% directory settings 

% prj_root_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path (for mac)
prj_root_path = 'C:\Users\kaito\workspace\2025_EEG_Analysis\EEG_Analysis_using_fieldtrip'; %project path (for windows)
cd(prj_root_path);

prj_name = 'graduation_thesis'; % adjust to project name
result_path = fullfile(prj_root_path, 'results', prj_name);
addpath(fullfile(prj_root_path, 'code')); % code directory

%% config - group comp
condition = 'CC';

condition_path = fullfile(result_path, condition);

%% load data
ExpAll = load(fullfile(condition_path, 'exp_all.mat'));
NovAll = load(fullfile(condition_path, 'nov_all.mat'));

dataExp = ExpAll.group_concat;
dataNov = NovAll.group_concat; 

%% extract Cz
cfg = [];
cfg.channel = 'Cz'; 
dataExp_Cz = ft_selectdata(cfg, dataExp);
dataNov_Cz = ft_selectdata(cfg, dataNov);

%% trim 
cfgT = [];
cfgT.toilim = [-0.5 1.0];
dataExp_Cz = ft_redefinetrial(cfgT, dataExp_Cz);
dataNov_Cz = ft_redefinetrial(cfgT, dataNov_Cz);

%% 
cfgF = [];
cfgF.method      = 'wavelet';      
cfgF.output      = 'fourier';      
cfgF.foi         = 2:1:40;         
cfgF.toi         = -0.5:0.01:1.0;  
cfgF.width       = 6;              
cfgF.keeptrials  = 'yes';
cfgF.channel     = 'Cz';           

freqExp = ft_freqanalysis(cfgF, dataExp_Cz);
freqNov = ft_freqanalysis(cfgF, dataNov_Cz);

Fexp = freqExp.fourierspctrm;
Fnov = freqNov.fourierspctrm; 

data1 = squeeze(permute(Fexp, [3 4 1 2])); 
data2 = squeeze(permute(Fnov, [3 4 1 2]));  

%% PhaseOpposition
[p_circWW, p_POS, p_zPOS] = PhaseOpposition(data1, data2);

%% axes from FieldTrip result
t = freqExp.time;          % 1 x T
f = freqExp.freq;          % 1 x F

% helper to force [F x T] shape
fixFT = @(P) ( ...
    isequal(size(P), [numel(f), numel(t)]) * P + ...
    isequal(size(P), [numel(t), numel(f)]) * P.' + ...
    (~isequal(size(P), [numel(f), numel(t)]) & ~isequal(size(P), [numel(t), numel(f)])) * error('Size mismatch: p-matrix not [F x T] or [T x F].') ...
);

P1 = fixFT(-log10(p_circWW));
P2 = fixFT(-log10(p_POS));
P3 = fixFT(-log10(p_zPOS));

figure;

% --- imagesc 版（推奨・速い） ---
subplot(1,3,1); imagesc(t, f, P1); axis xy tight; colorbar;
title('circWW  -log10(p)'); xlabel('Time (s)'); ylabel('Freq (Hz)'); hold on; xline(0,'w--');

subplot(1,3,2); imagesc(t, f, P2); axis xy tight; colorbar;
title('POS  -log10(p)');   xlabel('Time (s)'); ylabel('Freq (Hz)'); hold on; xline(0,'w--');

subplot(1,3,3); imagesc(t, f, P3); axis xy tight; colorbar;
title('zPOS -log10(p)');   xlabel('Time (s)'); ylabel('Freq (Hz)'); hold on; xline(0,'w--');

colormap('hot');