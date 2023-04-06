fig1 = figure;
ax1 = subplot(2,3,1);
[filter_data_spec, spec_freq_vec, spec_time_vec] = stft(data, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
clims = [max(pow2db(abs(filter_data_spec(:))))-30, max(pow2db(abs(filter_data_spec(:))))];
imagesc(spec_time_vec,spec_freq_vec, pow2db(abs(filter_data_spec)), clims)
colormap jet
fig1.Position = 1.0e+03 *[0    0.0530    1.5360    0.7408];
set(gca, "YDir", "normal")
xlabel("time");
ylabel("freq");
title("data")

ax2 = subplot(2,3,2);
[filter_echo_spec, spec_freq_vec, spec_time_vec] = stft(filtered_echo, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
clims = [max(pow2db(abs(filter_echo_spec(:))))-30, max(pow2db(abs(filter_echo_spec(:))))];
imagesc(spec_time_vec,spec_freq_vec, pow2db(abs(filter_echo_spec)), clims)
colormap jet
set(gca, "YDir", "normal");
xlabel("time");
ylabel("freq");
title("echo")

ax3 = subplot(2,3,3);
[filter_tx_spec, spec_freq_vec, spec_time_vec] = stft(filtered_tx, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
clims = [max(pow2db(abs(filter_tx_spec(:))))-30, max(pow2db(abs(filter_tx_spec(:))))];
imagesc(spec_time_vec,spec_freq_vec, pow2db(abs(filter_tx_spec)), clims)
colormap jet
set(gca, "YDir", "normal")
xlabel("time");
ylabel("freq");
title("tx")

% fig1.Position = [-1535          53        1536         739];
linkaxes([ax1, ax2, ax3], 'y')
% 
set(gca, "YLim", [75000, 90000])

subplot(2,3,4)
n_points = length(data);
cur_freq_axis = linspace(-n_points/2, (n_points-1)/2, n_points)*fs/n_points;
plot(cur_freq_axis ,abs(fftshift(fft(data))))
set(gca, "XLim", [75000, 90000])

subplot(2,3,5)
n_points = length(filtered_echo);
cur_freq_axis = linspace(-n_points/2, (n_points-1)/2, n_points)*fs/n_points;
plot(cur_freq_axis ,abs(fftshift(fft(filtered_echo))))
set(gca, "XLim", [75000, 90000])

subplot(2,3,6)
n_points = length(filtered_tx);
cur_freq_axis = linspace(-n_points/2, (n_points-1)/2, n_points)*fs/n_points;
plot(cur_freq_axis ,abs(fftshift(fft(filtered_tx))))
set(gca, "XLim", [75000, 90000])
