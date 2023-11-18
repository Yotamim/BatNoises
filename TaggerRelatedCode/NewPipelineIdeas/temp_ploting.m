function temp_ploting(spec_pb,freq_ax_pb,time_ax_pb,tagged_wav, fs,tx_freq)
clims = [max(pow2db(abs(spec_pb(:))))-25, max(pow2db(abs(spec_pb(:))))];
fig2 = figure;
move_figs_to_laptop_screen_Tali
subplot(2,3,1)
img = imagesc(time_ax_pb,freq_ax_pb, pow2db(abs(spec_pb)), clims);
colormap jet
set(gca, "YDir", "normal");
xlabel("time");
ylabel("freq");
spec_lim = get(gca,"XLim");
title("spectogram")
hold on 
plot(get(gca,"XLim"), [tx_freq,tx_freq], "k--")
ylim([7.6e4,8.3e4])

tresh = prctile(abs(spec_pb(:)),95);
subplot(2,3,2)
imagesc(time_ax_pb,freq_ax_pb, abs(spec_pb)>=tresh)
set(gca, "YDir", "normal");
xlabel("time");
ylabel("freq");
spec_lim = get(gca,"XLim");
title("bin spec")

subplot(2,3,3)
smooth_fftr = movmean(abs(fftshift(fft(tagged_wav))), 10);
xx = 0:fs/length(smooth_fftr):fs/2;
plot(xx, smooth_fftr(end-length(xx)+1:end))
xlim([7e4,8.2e4])
title("smooth fft")

subplot(2,3,4)
doppler_vec_2 = sum(abs(spec_pb).*(abs(spec_pb)>=tresh),2);
plot(freq_ax_pb,doppler_vec_2, "-")
xlim([7e4,8.2e4])
title("sum on spec times binary")

subplot(2,3,5)
doppler_vec = sum((abs(spec_pb)>=tresh),2);
plot(freq_ax_pb,doppler_vec, "-")
xlim([7e4,8.2e4])
title("binary sum on spec")

subplot(2,3,6)
doppler_vec_3 = sum(pow2db(abs(spec_pb)),2);
plot(freq_ax_pb,doppler_vec_3, "-")
xlim([7e4,8.2e4])
title("sum on db spec")

% figure;
% hold on
% axes = [];
% interesting_freqs = [7.2e4, 8.2e4];
% for ith_freq_row = 1:length(freq_ax_pb)
%     if freq_ax_pb(ith_freq_row) >= interesting_freqs(1) && freq_ax_pb(ith_freq_row) <= interesting_freqs(2)  
%         ax = nexttile;
%         plot(time_ax_pb, movmean(abs(spec_pb(ith_freq_row,:)),4));
%         axes = [axes, ax];
%         title(freq_ax_pb(ith_freq_row))
%     end
% end
% linkaxes(axes,"y")

end