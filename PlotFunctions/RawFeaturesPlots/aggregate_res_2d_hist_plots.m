tind = dominant_doppler<82000 & all_tx_freq>75000;
percent_used_data = sum(tind)/length(dominant_doppler);
nbins = [100,100];
min_color = 10;
Hist2dAsImage(all_tx_freq(tind), dominant_doppler(tind), nbins, min_color, percent_used_data)
xlabel("tx freq")
ylabel("rx freq")


tind =  all_tx_freq>76000 & all_tx_freq<79000 & ~isnan(all_speeds);
percent_used_data = sum(tind)/length(dominant_doppler);
nbins = [100,100];
min_color = 1;
Hist2dAsImage(all_speeds(tind), all_tx_freq(tind), nbins, min_color, percent_used_data)
xlabel("speed")
ylabel("tx freq")


tind = all_delays>0 & all_tx_freq>76500 & all_delays<0.01;
percent_used_data = sum(tind)/length(dominant_doppler);
nbins = [100,100];
min_color = 1;
Hist2dAsImage(all_tx_freq(tind), all_delays(tind), nbins, min_color, percent_used_data)
xlabel("tx freq")
ylabel("delay")


tind = dominant_doppler>76500 & ~isnan(all_speeds);
percent_used_data = sum(tind)/length(dominant_doppler);
nbins = [100,100];
min_color = 1;
Hist2dAsImage(all_speeds(tind), dominant_doppler(tind), nbins, min_color, percent_used_data)
xlabel("speed")
ylabel("rx freq")


