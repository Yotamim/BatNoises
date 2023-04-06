
% tx vs last dopp
tind = next_tx>75000 & last_dopp<83000;
% tind = true(size(next_tx));
percent_used_data = sum(tind)/length(dominant_doppler);
nbins = [100,100];
min_color = 1;
Hist2dAsImage(last_dopp(tind), next_tx(tind), nbins, min_color, percent_used_data)
xlabel("rx freq")
ylabel("tx freq")


tind = next_tx>76500 & last_tx>76500 & last_dopp<83000;
target_freq = 80000;
percent_used_data = sum(tind)/length(dominant_doppler);
nbins = [100,100];
min_color = 1;
Hist2dAsImage(target_freq -last_dopp(tind), next_tx(tind)-last_tx(tind), nbins, min_color, percent_used_data)
ylabel("rx diff")
xlabel("tx diff")



tind = next_tx>76500 & last_tx>76500 & last_dopp<83000;
target_freq = 79000;
percent_used_data = sum(tind)/length(dominant_doppler);
nbins = [100,100];
min_color = 1;
Hist2dAsImage(target_freq -last_dopp(tind), next_tx(tind)-last_tx(tind), nbins, min_color, percent_used_data)

tind = last_dopp<80500 & next_dop<80500 & last_dopp>79000 & next_dop>79000;
target_freq = 80000;
percent_used_data = sum(tind)/length(dominant_doppler);
nbins = [100,100];
min_color = 1;
Hist2dAsImage(last_dopp(tind), next_dop(tind), nbins, min_color, percent_used_data)
xlabel("last dop")
ylabel("next dop")