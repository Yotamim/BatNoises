bats = [2,4,5];
% tx vs rx
figure;
for i = 1:length(bats)
    subplot(1,3,i)
    tind = dominant_doppler<82000 & all_tx_freq>75000 & res_table_2_peaks.bat_num == bats(i);
    percent_used_data = sum(tind)/sum(res_table_2_peaks.bat_num == bats(i));
    nbins = [100,100];
    min_color = 1;
    [xy_corr, pval] = Hist2dAsImage(all_tx_freq(tind), dominant_doppler(tind), nbins, min_color, percent_used_data);
    xlabel("tx freq")
    ylabel("rx freq")
    title(sprintf("bat %.0f, per %.2f data \n corr = %.2f  pval= %.2e ", bats(i), percent_used_data, xy_corr, pval))
 end
fig = gcf;
linkaxes(fig.Children,"x","y")
sgtitle("tx vs rx")

% tx vs speed
figure;
for i = 1:length(bats)
    subplot(1,3,i)
    tind = abs(diff_to_closest_gps)<10 & all_tx_freq>75000 & res_table_2_peaks.bat_num == bats(i) ...
        & ~isnan(all_speeds);
    percent_used_data = sum(tind)/sum(res_table_2_peaks.bat_num == bats(i));
    nbins = [100,100];
    min_color = 1;
    [xy_corr, pval] = Hist2dAsImage(all_tx_freq(tind), all_speeds(tind), nbins, min_color, percent_used_data);
    xlabel("tx freq")
    ylabel("speed")
    title(sprintf("bat %.0f, per %.2f data \n corr = %.2f  pval= %.2e ", bats(i), percent_used_data, xy_corr, pval))
end
fig = gcf;
linkaxes(fig.Children,"x","y")
sgtitle("tx vs speed")

% rx vs speed
figure;
for i = 1:length(bats)
    subplot(1,3,i)
    tind = abs(diff_to_closest_gps)<10 & dominant_doppler<82000 & res_table_2_peaks.bat_num == bats(i);
    percent_used_data = sum(tind)/sum(res_table_2_peaks.bat_num == bats(i));
    nbins = [100,100];
    min_color = 1;
    [xy_corr, pval] = Hist2dAsImage(dominant_doppler(tind), all_speeds(tind), nbins, min_color, percent_used_data);
    xlabel("rx freq")
    ylabel("speed")
    title(sprintf("bat %.0f, per %.2f data \n corr = %.2f  pval= %.2e ", bats(i), percent_used_data, xy_corr, pval))
end
fig = gcf;
linkaxes(fig.Children,"x","y")
sgtitle("rx vs speed")


% rx vs rx var
figure;
for i = 1:length(bats)
    subplot(1,3,i)
    tind = dominant_doppler>77000& dominant_doppler<82000 & all_rx_var<1000 &res_table_2_peaks.bat_num == bats(i);
    percent_used_data = sum(tind)/sum(res_table_2_peaks.bat_num == bats(i));
    nbins = [100,100];
    min_color = 1;
    [xy_corr, pval] = Hist2dAsImage(dominant_doppler(tind), all_rx_var(tind), nbins, min_color, percent_used_data);
    xlabel("rx freq")
    ylabel("rx var")
    title(sprintf("bat %.0f, per %.2f data \n corr = %.2f  pval= %.2e ", bats(i), percent_used_data, xy_corr, pval))
end
fig = gcf;
linkaxes(fig.Children,"x","y")
sgtitle("rx vs rx var")

% tx 7db vs rx var
figure;
for i = 1:length(bats)
    subplot(1,3,i)
    tind =  all_tx_7db< 1000 & all_rx_var<1000 &res_table_2_peaks.bat_num == bats(i);
    percent_used_data = sum(tind)/sum(res_table_2_peaks.bat_num == bats(i));
    nbins = [100,100];
    min_color = 1;
    [xy_corr, pval] = Hist2dAsImage(all_tx_7db(tind), all_rx_var(tind), nbins, min_color, percent_used_data);
    xlabel("tx 7 db")
    ylabel("rx var")
    title(sprintf("bat %.0f, per %.2f data \n corr = %.2f  pval= %.2e ", bats(i), percent_used_data, xy_corr, pval))
end
fig = gcf;
linkaxes(fig.Children,"x","y")
sgtitle("tx var vs rx var")


