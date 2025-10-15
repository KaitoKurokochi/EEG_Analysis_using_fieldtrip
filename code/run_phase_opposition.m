%% directory settings 

prj_root_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path (for mac)
% prj_root_path = 'C:\Users\kaito\workspace\2025_EEG_Analysis\EEG_Analysis_using_fieldtrip'; %project path (for windows)
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
cfg = [];
cfg.method = 'wavelet';
cfg.output = 'pow';
cfg.foi    = 2:1:40;
cfg.toi    = dataExp_Cz.time{1}(1):0.01:dataExp_Cz.time{1}(end);
powExp = ft_freqanalysis(cfg, dataExp_Cz);
powNov = ft_freqanalysis(cfg, dataNov_Cz);         

%% 
cfg = [];
cfg.method           = 'montecarlo';
cfg.statistic        = 'indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.numrandomization = 2000;

nExp = numel(624); 
nNov = numel(569);
cfg.design = [ones(1,nExp), 2*ones(1,nNov)];
cfg.ivar   = 1;

stat = ft_freqstatistics(cfg, powExp, powNov);

%% graph 
% 1) 次元を落として 2D にする（chan 次元を squeeze）
Tmap = squeeze(stat.stat);      % -> [freq x time] になる想定
Mmap = squeeze(stat.mask);      % 同様に 2D に

% 2) サイズ整合をチェック
% rows = length(stat.freq), cols = length(stat.time)
assert(ismatrix(Tmap), 'Tmap must be 2D');
assert(size(Tmap,1) == numel(stat.freq) && size(Tmap,2) == numel(stat.time), ...
    'Size mismatch: got [%d %d], expected [%d %d]', size(Tmap,1), size(Tmap,2), numel(stat.freq), numel(stat.time));

% 3) 描画
figure;
imagesc(stat.time, stat.freq, Tmap);  % C は [freq x time]
axis xy; colorbar;
xlabel('Time (s)'); ylabel('Frequency (Hz)');
title('T-value map');
colormap jet;

% 4) 有意クラスタを重ねる（mask がある場合）
if ~isempty(Mmap)
    hold on;
    contour(stat.time, stat.freq, Mmap, [1 1], 'w', 'LineWidth', 1.5);
end