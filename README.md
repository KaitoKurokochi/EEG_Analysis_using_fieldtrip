# EEG_Analysis_using_fieldtrip
My EEG analysis code with using fieldtrip -> [link](https://github.com/fieldtrip/fieldtrip)

# how to use fieldtrip in Matlab 
- [link](https://www.fieldtriptoolbox.org/faq/matlab/installation/)
- make `startup.m` in `MATLAB` directory


# 20250923 
- `main.m`の`prj_root_path`はmac/windowsで合わせる
- `prj_name`は各プロジェクトに合わせる

## projectのディレクトリ構造
```sh
C:.
├─code
├─rawdata
│  └─sample
└─results
    └─sample
```
`rawdata`, `results`にはprojectごとにディレクトリを作成

## Processing 
0. read data
1. filtering (1-30Hz)
2. ICA 
3. remove noise components 
4. epoching 

## Others 
- `.asv`ファイルの追跡をしない
