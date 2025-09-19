%% make raw data

cfg = [];
cfg.dataset     = '';
EEG_raw         = ft_preprocessing(cfg);

% Marker
cfg = [];
cfg.dataset     = '';
cfg.trialdef.eventtype = '?';
dummy                   = ft_definetrial(cfg);

marker = [118792;11099766;14978455;24838276];

EEG_1 = EEG_raw;
EEG_1.trial{1,1} = EEG_raw.trial{1,1}(:, marker(1):marker(2));
EEG_1.time{1,1}  = [0:1/2000:1/2000*(length(EEG_1.trial{1,1})-1)];
EEG_1.sampleinfo(2) = length(EEG_1.trial{1,1});
EEG_2 = EEG_raw;
EEG_2.trial{1,1} = EEG_raw.trial{1,1}(:, marker(2):marker(3));
EEG_2.time{1,1}  = [0:1/2000:1/2000*(length(EEG_2.trial{1,1})-1)];
EEG_2.sampleinfo(2) = length(EEG_2.trial{1,1});
EEG_3 = EEG_raw;
EEG_3.trial{1,1} = EEG_raw.trial{1,1}(:, marker(3):marker(4));
EEG_3.time{1,1}  = [0:1/2000:1/2000*(length(EEG_3.trial{1,1})-1)];
EEG_3.sampleinfo(2) = length(EEG_3.trial{1,1});

save EEG_1 EEG_1 -v7.3;
save EEG_2 EEG_2 -v7.3;
save EEG_3 EEG_3 -v7.3;

% lp-filter
cfg                = [];
cfg.lpfilter       = 'yes';        % enable low-pass filtering
cfg.lpfreq         = 95;          % set up the frequency for low-pass filter
EEG_1_lp           = ft_preprocessing(cfg,EEG_1);
EEG_2_lp           = ft_preprocessing(cfg,EEG_2);
EEG_3_lp           = ft_preprocessing(cfg,EEG_3);


%% ICA
cfg        = [];
cfg.channel = {'all', '-EOG'};
cfg.method = 'runica'; % this is the default and uses the implementation from EEGLAB
cfg.runica.pca = 20; % s = 80 comps
% 1‰ñ–Ú
comp_1     = ft_componentanalysis(cfg, EEG_1_bs);
save comp_1 comp_1 -v7.3;
comp_2     = ft_componentanalysis(cfg, EEG_2_bs);
save comp_2 comp_2 -v7.3;
comp_3     = ft_componentanalysis(cfg, EEG_3_bs);
save comp_3 comp_3 -v7.3;

figure;
cfg = []; %component
cfg.component = [1:10];
cfg.layout    = 'easycapM11.mat'; % specify the layout file that should be used for plotting
% cfg.comment   = 'no';
ft_topoplotIC(cfg, comp_1);

%component and wave
cfg = [];
cfg.channel = [1:20]; % components to be plotted
cfg.viewmode = 'component';
cfg.layout = 'easycapM11.mat'; % specify the layout file that should be used for plotting
ft_databrowser(cfg, comp_1);
% ft_databrowser(cfg, comp_2);
% ft_databrowser(cfg, comp_3);

% Remove noise components
cfg = [];
cfg.component = [1 3 6]; % comp_1
% cfg.component = [1 2]; % comp_2
% cfg.component = [1]; % comp_3
EEG_1_c1 = ft_rejectcomponent(cfg, comp_1, EEG_1_bs);
% EEG_2_c1 = ft_rejectcomponent(cfg, comp_2, EEG_2_bs);
% EEG_3_c1 = ft_rejectcomponent(cfg, comp_3, EEG_3_bs);

save EEG_1_c1 EEG_1_c1 -v7.3;
save EEG_2_c1 EEG_2_c1 -v7.3;
save EEG_3_c1 EEG_3_c1 -v7.3;







