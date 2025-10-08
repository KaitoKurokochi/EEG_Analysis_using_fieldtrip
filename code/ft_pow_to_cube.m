function X = ft_pow_to_cube(freq_pow, chanIdx)
% freq_pow.powspctrm: [rpt x chan x freq x time]
X = permute(freq_pow.powspctrm(:, chanIdx, :, :), [3 4 1 2]); % -> [F x T x N x 1]
X = X(:, :, :, 1);
end