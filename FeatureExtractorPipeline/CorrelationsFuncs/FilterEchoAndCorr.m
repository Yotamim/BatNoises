function [start_time_tx,start_time_echo,freq_xcor,freq_lags, filt_echo, filt_tx, tx_freq,...
    filtered_echo, filtered_tx, smooth_tx_fft_var, smooth_echo_fft_var] = ...
FilterEchoAndCorr(data, fs, tx_freq_range, echo_freq_range, expand_dop_search, PLOT_FLAG, config)

n_points = length(data);
t_vec = (0:length(data)-1)/fs;
f_vec = linspace(-n_points/2, (n_points-1)/2, n_points).'*fs/n_points;

[filtered_tx, filt_tx] = bandpass(data, tx_freq_range, fs, "Steepness",0.99);
[filtered_echo, filt_echo] = bandpass(data, echo_freq_range, fs,"Steepness",0.99);


[echo_freq_range, tx_freq_range, assertion_res] = AssertNoFrequencyOverlap(filt_echo, filt_tx, tx_freq_range, echo_freq_range);
if assertion_res
    [filtered_echo, filt_echo]= bandpass(data, echo_freq_range, fs,"Steepness",0.99);
    [filtered_tx,filt_tx] = bandpass(data, tx_freq_range, fs, "Steepness",0.99);
end


if expand_dop_search
    new_freq_range = [echo_freq_range(1),fs/2.1];
    [filtered_echo, filt1]= bandpass(data, new_freq_range, fs,"Steepness",0.99);
end

smooth_echo_fft = movmean(abs(fftshift(fft(hilbert(filtered_echo)))), 5);
smooth_tx_fft = movmean(abs(fftshift(fft(hilbert(filtered_tx)))), 5);

smooth_tx_fft_var = var(smooth_tx_fft);
smooth_echo_fft_var = var(smooth_echo_fft);

[~,tx_freq_ind] = max(smooth_tx_fft);
tx_freq = abs(f_vec(tx_freq_ind));
[freq_xcor,freq_lags] = xcorr(abs(smooth_echo_fft),abs(smooth_tx_fft));
[vectx, start_time_tx] = FindStartTimeFromCutSpec(filtered_tx, fs, config, true);
[vectecho, start_time_echo] = FindStartTimeFromCutSpec(filtered_echo,  fs, config, false);
if 0
    %     carrier_wave_rx = exp(-2*pi*1i*mean(echo_freq_range)*t_vec ).';
    %     carrier_wave_tx = exp(-2*pi*1i*mean(tx_freq_range)*t_vec ).';
    %
    %     bb_rx = carrier_wave_rx.*hilbert(filtered_echo);
    %     bb_tx = carrier_wave_tx.*hilbert(filtered_tx);

    config = GetConfig;

    figure;
    subplot(2,3,1)
    plot(f_vec, abs(fftshift(fft(data))))
    subplot(2,3,2)
    plot(f_vec, abs(fftshift(fft(filtered_tx)))); hold on
    plot(f_vec, abs(fftshift(fft(filtered_echo))))
    subplot(2,3,3)
    plot(t_vec, data);
    
    title("filtered time signal")

    ax4 = subplot(2,3,4);
    [spec, f_axis_spec, t_axis_spec] = stft(data, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
    imim = pow2db(abs(spec));
    climsss = [max(imim(:))-30, max(imim(:))];
    imagesc(t_axis_spec,f_axis_spec, imim ,climsss )
    colormap jet
    set(gca, "YDir", "normal")
    xlabel("time");
    ylabel("freq");
    spec_lim = get(gca,"XLim");
    title("spectogram")

    ax5 = subplot(2,3,5);
    [spec, f_axis_spec, t_axis_spec] = stft(filtered_tx, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
    imagesc(t_axis_spec,f_axis_spec, pow2db(abs(spec)))
    colormap jet
    set(gca, "YDir", "normal")
    xlabel("time");
    ylabel("freq");
    spec_lim = get(gca,"XLim");
    title("spectogram")

    ax6 = subplot(2,3,6);
    [spec, f_axis_spec, t_axis_spec] = stft(filtered_echo, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
    imim = pow2db(abs(spec));
    climsss = [max(imim(:))-30, max(imim(:))];
    imagesc(t_axis_spec,f_axis_spec, imim)
    colormap jet
    set(gca, "YDir", "normal")
    xlabel("time");
    ylabel("freq");
    spec_lim = get(gca,"XLim");
    title("spectogram")
    linkaxes([ax4, ax5, ax6], 'x')
    move_fig_to_laptop_screen_home

%     figure; plot(t_axis_spec,vectx); hold on; plot(t_axis_spec,vectecho)
%     plot(start_timeecho,0,"*")
%     plot(start_timetx,0,"*")
%     disp(start_timeecho)
%     disp(start_timetx)
end
end
