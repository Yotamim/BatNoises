bat_num = 4;
txtx = res_table(res_table.bat_num == bat_num,:).raw_tx;
gps_secs = res_table(res_table.bat_num == bat_num,:).closest_gps_time*24*3600;
tx_times_secs_abs = gps_secs+res_table(res_table.bat_num == bat_num,:).diff_from_closest_gps;
speedss = res_table(res_table.bat_num == bat_num,:).speed;
figure;
plot(tx_times_secs_abs, txtx, "."); hold on
plot(tx_times_secs_abs(~isnan(speedss)), speedss(~isnan(speedss))*500+78000, "o"); hold on


clear;
bat_num = [2,4,5];
for i = bat_num
    gps = LoadGpsData(num2str(i));

    x = movmean(gps.x,1);
    y = movmean(gps.y,1);
    figure; plot(x,y, ".")
    dist_steps = sqrt(diff(x).^2+diff(y).^2);
    vel = dist_steps./(diff(gps.time)*24*3600);
    t_vec = (gps.time-min(gps.time))*24*3600;
    figure; subplot(1,3,1)
    plot(t_vec(2:end),vel, ".")
    subplot(1,3,2)
    plot(t_vec(2:end),x(2:end), ".")
    subplot(1,3,3)
    plot(t_vec(2:end),y(2:end), ".")
    linkaxes(get(gcf,"children"), "x")
end