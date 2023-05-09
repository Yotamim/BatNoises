function [cut_spec_sum_time, start_time] = FindStartTimeFromCutSpec(data, fs, config, tx_flag)

[spec, f_axis_spec, t_axis_spec] = stft(data, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
spec_db = pow2db(abs(spec));
spec_sum_freq = sum(abs(spec),2);
[~, ind_max_freq] = max(spec_sum_freq);
if tx_flag
    factor_of_start = 0.2;
    cut_spec = abs(spec);
else
    factor_of_start = 0.333;
    range_arond_max_freq = 100;
    cut_spec = abs(spec(ind_max_freq-range_arond_max_freq :ind_max_freq+range_arond_max_freq ,:));
end

cut_spec_sum_time = movmean(sum(cut_spec,1), 5);
max_energy_over_time = max(cut_spec_sum_time);



start_time = t_axis_spec(cut_spec_sum_time/max_energy_over_time>factor_of_start);
start_time = start_time(1);

% figure; 
% climsss = [max(cut_spec(:))-30, max(cut_spec(:))];
% if ~tx_flag
%     imagesc(t_axis_spec,f_axis_spec(ind_max_freq-range_arond_max_freq :ind_max_freq+range_arond_max_freq), pow2db(cut_spec), climsss )
% else
%     imagesc(t_axis_spec,f_axis_spec, pow2db(cut_spec), climsss )
% end
% colormap jet
% set(gca, "YDir", "normal")
% xlabel("time");
% ylabel("freq");
% spec_lim = get(gca,"XLim");
% title("spectogram")

end