# EEG_Analysis_using_fieldtrip
My EEG analysis code with using fieldtrip -> [link](https://github.com/fieldtrip/fieldtrip)

# how to use fieldtrip in Matlab 
- [link](https://www.fieldtriptoolbox.org/faq/matlab/installation/)
- make `startup.m` in `MATLAB` directory

# order of execution 
## 1. data_organization
各条件、各グループのデータをまとめる

## 2. spectrum_analysis
各条件、各グループでまとめたデータを周波数解析し、結果を`.m`ファイルに保存

# 20250923 
- `main.m`の`prj_root_path`はmac/windowsで合わせる
- `prj_name`は各プロジェクトに合わせる


## projectの構造
```sh
C:.
├─code
├─rawdata
│  └─sample
└─results
    └─sample
```
`rawdata`, `results`にはprojectごとにディレクトリを作成

## Others 
- `.asv`ファイルの追跡をしない

# 20251006 Z-scoreによるtime-frequency analysisの比較の実装
1. データをまとめるスクリプト
各グループ，各条件の試行をまとめたファイルが必要
例）経験者のCC条件のファイルはexp_cc.m

2. 条件・グループごと周波数解析するスクリプト
各条件・グループごとに時間x周波数のヒートマップが作れるようにする

3. 周波数解析の結果を比較するスクリプト
z-scoreを用いた解析ができるようにする
