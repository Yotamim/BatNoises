close all
figure;
tind = all_tx_freq>7.5e4;
plot(all_tx_freq(tind), dominant_doppler(tind), "."); hold on
axis equal
xlim = get(gca, "XLim");
ylim = get(gca, "YLim");
min_lim = min([ylim, xlim]);
max_lim = max([ylim, xlim]);
plot([min_lim,max_lim], [min_lim,max_lim])
set(gca, "XLim", xlim);
set(gca, "YLim", ylim);
% if ~isfile(fig_dir+"scatter_rx_freq_tx_freq.fig")
%     savefig(fig_dir+"scatter_rx_freq_tx_freq")
% end


figure; 
tind = all_tx_freq>7.5e4;
scatter(all_speeds(tind), all_tx_freq(tind), ".")
title("tx freq vs speed")
% if ~isfile(fig_dir+"scatter_speed_tx_freq.fig")
%     savefig(fig_dir+"scatter_speed_tx_freq")
% end


figure; 
scatter(all_tx_freq(all_delays>0), all_delays(all_delays>0), ".")
title("delay vs tx freq")
% if ~isfile(fig_dir+"scatter_delay_tx_freq.fig")
%     savefig(fig_dir+"scatter_delay_tx_freq")
% end
figure; 
scatter(all_speeds(all_delays>0), all_delays(all_delays>0), ".")
title("delay vs speed")
% if ~isfile(fig_dir+"scatter_delay_speed.fig")
%     savefig(fig_dir+"scatter_delay_speed")
% end


figure; 
tind = all_delays>0 & all_delays<0.006;
scatter(all_delays(tind), dominant_doppler(tind), ".")
title("rx freq vs delay")
% if ~isfile(fig_dir+"scatter_delay_rx_freq.fig")
%     savefig(fig_dir+"scatter_delay_rx_freq")
% end