% load('data_raw_Geo_collecting_0907.mat')
% x=cell2mat({data.lon});
% y=cell2mat({data.lat});
% figure;
% lon = [34.808 34.809 34.81]; 
% lat = [32.1122 32.112 32.1125]; 
% 
% plot(x,y,'.r','MarkerSize',3) 

bat_num = [2,4,5];
for i = bat_num
    wavs_dates = all_wav_times(all_bat_nums == i);
    wav_dates_days = etime(datevec(wavs_dates), datevec(gps_epoch))/3600/24;
    gps = LoadGpsData(num2str(i));
    lon = gps.lon;
    lat = gps.lat;
    
    gps_t_vec = (gps.time-min(gps.time))*24*3600;
    wav_dates_alligned = (wav_dates_days-min(gps.time))*24*3600;
    figure;
    subplot(2,3,1)
    plot(lon,lat,'.r','MarkerSize',2) 
    xlabel("lon")
    ylabel("lat")
    plot_google_map('MapType','satellite')

    subplot(2,3,2)
    plot(gps_t_vec,lon, ".")
    hold on;
    plot(wav_dates_alligned, ones(size(wav_dates_alligned))*mean(lon), "o")
    xlabel("t")
    ylabel("x")
    
    subplot(2,3,3)
    plot(gps_t_vec,lat, ".")
    hold on;
    plot(wav_dates_alligned, ones(size(wav_dates_alligned))*mean(lat), "o")
    xlabel("t")
    ylabel("y")
    
    axises = get(gcf,"children");
    linkaxes(axises(1:2), "x")
    linkaxes(axises([1,3]), "y")
    sgtitle("bat"+num2str(i))

    subplot(2,3,4)
    plot(gps_t_vec,gps.speed, ".")
    hold on;
    plot(wav_dates_alligned, ones(size(wav_dates_alligned))*nanmean(gps.speed), "o")
    xlabel("t")
    ylabel("speed")

    subplot(2,3,5)
    vel_from_locs = sqrt(diff(lon).^2+diff(lat).^2)./diff(gps_t_vec);
    plot(gps_t_vec(1:end-1),vel_from_locs, ".")
    hold on;
    plot(wav_dates_alligned, ones(size(wav_dates_alligned))*nanmean(gps.speed), "o")
    xlabel("t")
    ylabel("vel from locs")

    subplot(2,3,6)
    vel_from_locs = sqrt(diff(lon).^2+diff(lat).^2)./diff(gps_t_vec);
    plot(gps_t_vec(2:end),vel_from_locs-gps.speed(2:end), ".")
    hold on;
    
    plot(wav_dates_alligned, zeros(size(wav_dates_alligned)), "o")
    xlabel("t")
    ylabel("speed - vel from loc")
    
end

