function IsSameFreqEcho(spec, smooth_fft, freqs, spec_freq_vec, prctile_thresh)
sinc_width = 3123;
sinc_spec_width = sinc_width/(spec_freq_vec(2)-spec_freq_vec(1));

[~, ind_max] = max(smooth_fft);
[~,spec_max_freq_ind] = max(sum(spec,2));

spec_background_noise_lvl = prctile(spec(:),prctile_thresh);

figure; plot(spec(spec_max_freq_ind,:))
spec_max_freq = spec_freq_vec(spec_max_freq_ind);

if 0 
    figure;
    A = spec>spec_background_noise_lvl;
    filter_spec = spec.*A+0.0000001;
    clims = [max(pow2db(filter_spec(:)))-30, max(pow2db(filter_spec(:)))];
    img = imagesc(pow2db(filter_spec), clims);
    colormap jet
    set(gca, "YDir", "normal")
    xlabel("time");
    ylabel("freq");
    title("other")
%     ylim([7.5e4,8.3e4])

end
end