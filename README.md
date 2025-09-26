# EEG_Analysis_using_fieldtrip
My EEG analysis code with using fieldtrip -> [link](https://github.com/fieldtrip/fieldtrip)

# how to use fieldtrip in Matlab 
- [link](https://www.fieldtriptoolbox.org/faq/matlab/installation/)
- make `startup.m` in `MATLAB` directory

# Directory structure of this project
```sh
C:.
├─code
├─rawdata
│  └─sample
└─results
    └─sample
```

# 20250926 
## flow of processing 
1. read EEG data
2. read CSV file (`all_sequence.csv`)
3. bp_filter (1-30Hz) 
4. epoching (-1.5-2.0s around `s4`) 
5. labeling -> change `s4` signal for each condition 
6. divide by conditions 
7. save data 
