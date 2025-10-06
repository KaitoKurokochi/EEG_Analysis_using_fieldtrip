%% default for my project
% prj_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path (for mac)
prj_root_path = 'C:\Users\kaito\workspace\2025_EEG_Analysis\EEG_Analysis_using_fieldtrip'; %project path (for windows)
cd(prj_root_path);

prj_name = 'graduation_thesis'; % adjust to project name

rawdata_path = fullfile(prj_root_path, 'rawdata', prj_name); % rawdata directory
result_path = fullfile(prj_root_path, 'results', prj_name); % result
addpath(fullfile(prj_root_path, 'code')); % code directory 

%% data organization 
condition = 'CC';
group = 'exp';

condition_path = fullfile(rawdata_path, condition);
files = dir(fullfile(condition_path, [group, '*.set']));

data_all = cell(numel(files), 1);
subj_ids = strings(numel(files), 1);

for i = 1:numel(files)
    setfile = fullfile(condition_path, files(i).name);
    [~, base] = fileparts(setfile);
    subj_ids(i) = string(base);

    cfg = [];
    cfg.dataset   = setfile;     
    data_all{i} = ft_preprocessing(cfg);
    fprintf('Loaded: %s\n', setfile);
end

%% append data
cfg = [];
group_concat = ft_appenddata(cfg, data_all{:});

%% save 
save_name = sprintf('%s_all.mat', group); 
save_dir  = fullfile(result_path, condition);
save_path = fullfile(save_dir, save_name);

if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

save(save_path, 'group_concat', 'subj_ids', '-v7.3');

fprintf('\n✅ Saved concatenated data to:\n%s\n', save_path);