function [fig1] = PlotSpectogram(time_signal, stft, fs, f_axis_spec, t_axis_spec)

fig1 = figure; 
ax1 = subplot(2,1,1);
imagesc(t_axis_spec,f_axis_spec, pow2db(abs(stft)))
colormap jet
% fig1.Position = 1.0e+03 *[-1.5350    0.0530    1.5360    0.7408];
fig1.Position = 1.0e+03 *[0    0.0530    1.5360    0.7408];
fig1.Children.YDir = "normal";
xlabel("time");
ylabel("freq");
spec_lim = get(gca,"XLim");
title("spectogram")

ax2 = subplot(2,1,2);
plot([0:1:length(time_signal)-1]/fs, time_signal)
ax2.set("XLim", spec_lim)
xlabel("time");

linkaxes([ax1, ax2], 'x')

end