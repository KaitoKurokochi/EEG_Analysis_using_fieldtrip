function [p_diff, eff_diff] = MyPowerOpposition(A_pow, B_pow, nperm)
% A_pow, B_pow: [F x T x N] (dB power)
% two-sided label permutation on mean difference
if nargin<3, nperm = 2000; end
[F,T,NA] = size(A_pow);
[~,~,NB] = size(B_pow);
ALL = cat(3, A_pow, B_pow);
N = NA + NB;

muA = mean(A_pow, 3);
muB = mean(B_pow, 3);
obs = muA - muB; eff_diff = obs;

ge = zeros(F,T); abs_obs = abs(obs);
for k = 1:nperm
    idx  = randperm(N);
    Aidx = idx(1:NA);
    Bidx = idx(NA+1:end);
    perm_stat = mean(ALL(:,:,Aidx),3) - mean(ALL(:,:,Bidx),3);
    ge = ge + (abs(perm_stat) >= abs_obs);
end
p_diff = (ge + 1) ./ (nperm + 1);
end