function [time_xcor,time_lags,freq_xcor,freq_lags, filt_echo, filt_tx] = FilterEchoAndCorr(data, fs, tx_freq_range, echo_freq_range, expand_dop_search, PLOT_FLAG)

n_points = length(data);
t_vec = (0:length(data)-1)/fs;
f_vec = linspace(-n_points/2, (n_points-1)/2, n_points).'*fs/n_points;
carrier_wave_rx = exp(-2*pi*1i*mean(echo_freq_range)*t_vec ).';
carrier_wave_tx = exp(-2*pi*1i*mean(tx_freq_range)*t_vec ).';

[filtered_echo, filt_echo] = bandpass(data, echo_freq_range, fs,"Steepness",0.99);
[filtered_tx, filt_tx] = bandpass(data, tx_freq_range, fs, "Steepness",0.99);


[echo_freq_range, tx_freq_range, assertion_res] = AssertNoFrequencyOverlap(filt_echo, filt_tx, tx_freq_range, echo_freq_range);
if assertion_res
    [filtered_echo, filt_echo]= bandpass(data, echo_freq_range, fs,"Steepness",0.99);
    [filtered_tx,filt_tx] = bandpass(data, tx_freq_range, fs, "Steepness",0.99);
end
[time_xcor,time_lags] = xcorr(abs(filtered_echo),abs(filtered_tx));

if expand_dop_search
    new_freq_range = [echo_freq_range(1),fs/2.1];
    [filtered_echo, filt1]= bandpass(data, new_freq_range, fs,"Steepness",0.99);
end

smooth_echo_fft = movmean(abs(fftshift(fft(hilbert(filtered_echo)))), 5);
smooth_tx_fft = movmean(abs(fftshift(fft(hilbert(filtered_tx)))), 5);


bb_rx = carrier_wave_rx.*hilbert(filtered_echo);
bb_tx = carrier_wave_tx.*hilbert(filtered_tx);

if PLOT_FLAG
    subplot(2,3,2)
    plot(t_vec, real(bb_rx));hold on;
    plot(t_vec, real(bb_tx)); 
    title("filtered time signal")

    subplot(2,3,3)
    plot(f_vec, smooth_echo_fft);hold on;
    plot(f_vec, smooth_tx_fft)
    title("filtered fft signal")
end

[freq_xcor,freq_lags] = xcorr(abs(smooth_echo_fft),abs(smooth_tx_fft));
end