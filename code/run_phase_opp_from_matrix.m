%% load data
prj_root_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip';
prj_name  = 'graduation_thesis';
cond      = 'CC';

res_dir = fullfile(prj_root_path, 'results', prj_name, cond);
S = load(fullfile(res_dir, 'exp_all.mat')); exp_all = S.group_concat;
S = load(fullfile(res_dir, 'nov_all.mat')); nov_all = S.group_concat;

%% TFR (power, trialwise)
toi  = -1.0:0.01:1.5;      % 10 ms step
foi  = 2:1:30;             % Hz
tftw = 4 ./ foi;           % 4 cycles / freq
chanSel = {'Cz'};
bl_win  = [-0.5 0];        % dB baseline

cfg = [];
cfg.method     = 'mtmconvol';   % or 'wavelet'
cfg.output     = 'pow';
cfg.taper      = 'hanning';
cfg.keeptrials = 'yes';
cfg.foi        = foi;
cfg.toi        = toi;
cfg.t_ftimwin  = tftw;
cfg.channel    = chanSel;

tfr_exp = ft_freqanalysis(cfg, exp_all);   % rpt_chan_freq_time
tfr_nov = ft_freqanalysis(cfg, nov_all);

cfgb = []; cfgb.baseline = bl_win; cfgb.baselinetype = 'db';
tfr_exp = ft_freqbaseline(cfgb, tfr_exp);
tfr_nov = ft_freqbaseline(cfgb, tfr_nov);

assert(isequaln(tfr_exp.time, tfr_nov.time) && isequaln(tfr_exp.freq, tfr_nov.freq), ...
  'time/freq mismatch');
times = tfr_exp.time; freqs = tfr_exp.freq;

[~, chE] = ismember('Cz', tfr_exp.label);
[~, chN] = ismember('Cz', tfr_nov.label);
assert(chE>0 && chN>0, 'Cz not found in labels');

XA = ft_pow_to_cube(tfr_exp, chE); 
XB = ft_pow_to_cube(tfr_nov, chN); 

twin  = [-0.5 1.0];
tMask = times >= twin(1) & times <= twin(2);
XA = XA(:, tMask, :);
XB = XB(:, tMask, :);
t_sub = times(tMask);

%% power opposition
[p_diff, eff_diff] = MyPowerOpposition(XA, XB, 2000);

%% Plot & save
f = figure('Color','w');
subplot(1,2,1);
imagesc(t_sub, freqs, eff_diff); axis xy;
title('exp - nov (power, dB)'); xlabel('Time (s)'); ylabel('Hz'); colorbar;

subplot(1,2,2);
imagesc(t_sub, freqs, -log10(p_diff)); axis xy;
title('-log10 p (permutation)'); xlabel('Time (s)'); ylabel('Hz'); colorbar;

sgtitle(sprintf('Cz | %s | Trials pooled (Nexp=%d, Nnov=%d)', ...
  cond, size(XA,3), size(XB,3)));

out_png = fullfile(prj_root_path, 'results', prj_name, 'power_opposition_comp', 'power_perm_exp_vs_nov_Cz_trialsPooled.png');
saveas(f, out_png);
fprintf('\n✅ Saved: %s\n', out_png);