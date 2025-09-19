%% default for my project
prj_path = '/Users/kurokochikaito/workspace/2025_eeg_analysis/EEG_Analysis_using_fieldtrip'; %project path 
cd(prj_path);

raw_data_path  = fullfile(prj_path, 'rawdata'); % rawdata directory

addpath(fullfile(prj_path, 'code')); % code directory 

%% eeg and vhdr files 
datadir = fullfile(raw_data_path, 'sample_data');
hdrfile = fullfile(datadir, 's04.vhdr');
eegfile = fullfile(datadir, 's04.eeg');
