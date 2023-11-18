config = GetConfig;

figure; histogram(dominant_doppler(tind)./all_tx_freq(tind))
title("hist of rx/tx ratio (trimmed hist)")

figure; histogram(all_tx_freq,500)
title("hist of tx freq")

figure; histogram(all_tx_freq(abs(all_speeds)<1),500, Normalization="probability")
title("hist of tx freq")
hold on
histogram(all_tx_freq(abs(all_speeds)>4),500, Normalization="probability")
title("hist of tx freq")


figure; histogram(all_speeds,500)
title("hist of speeds")


figure; histogram(dominant_doppler(all_speeds(tind)>4), 500, Normalization="probability")
title("hist of rx freq")
hold on
histogram(dominant_doppler(all_speeds(tind)<1), 500, Normalization="probability")
title("hist of rx freq")
hold on 
histogram(all_tx_freq, 500)

figure; histogram(all_delays(all_delays>0 & all_delays<0.1),500)
title("hist of delays")

ratio_speed = (all_tx_freq(tind).*abs(all_speeds(tind)))./dominant_doppler(tind);
figure; histogram(ratio_speed(ratio_speed<10), 100)
title("rx ratio/tx*speed (trimmed hist)")
