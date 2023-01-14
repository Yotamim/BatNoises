function [wav_stft, t, f, fig1] = PlotSpectogram(wav_data, fs, win_size, freq_range, overlap, window, PLOT_FLAG)

[wav_stft,f,t] = stft(wav_data,fs, FFTLength=win_size,FrequencyRange=freq_range, OverlapLength=overlap, Window=window);

fig1 = figure; 
ax1 = subplot(2,1,1);
imagesc(t,f, pow2db(abs(wav_stft)))
fig1.Position = 1.0e+03 *[-1.5350    0.0530    1.5360    0.7408];
fig1.Children.YDir = "normal";
xlabel("time");
ylabel("freq");
spec_lim = get(gca,"XLim");
title("spectogram")

ax2 = subplot(2,1,2);
plot([0:1:length(wav_data)-1]/fs, wav_data)
ax2.set("XLim", spec_lim)
xlabel("time");

linkaxes([ax1, ax2], 'x')

end